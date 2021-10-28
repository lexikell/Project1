#from "R Bioinformatics BLAST metagenomics" Rob H YouTube
#metatranscriptomics of a covidpatient sample

#install bc packages
library(rBLAST)
#lookup taxonomy for every blast data
library(taxonomizr)
#speeds up (paralell)
library(parallel)
#both for visualizing data
library(ggplot2)
library(forcats)

# set up workspace
#dir.create makes the folder, metagenomics is the name of the dir
dir.create('metagenomics')
#move into that folder (cd))
setwd('metagenomics')

#making sub-directories for the reference data and the raw data:
# ref
#download the viral genomic reference data from ncbi from the "ftp server"
#we're downloading three files, unzipping them, and then combining them together for the blast db
dir.create('ref')
download.file('ftp://ftp.ncbi.nlm.nih.gov/refseq/release/viral/viral.1.1.genomic.fna.gz', 'ref/viral.1.1.genomic.fna.gz')
#I'm guessing: "download.file" is the function to download; then the download link; then where/what you want to save as
download.file('ftp://ftp.ncbi.nlm.nih.gov/refseq/release/viral/viral.2.1.genomic.fna.gz', 'ref/viral.2.1.genomic.fna.gz')
download.file('ftp://ftp.ncbi.nlm.nih.gov/refseq/release/viral/viral.3.1.genomic.fna.gz', 'ref/viral.3.1.genomic.fna.gz')
system("gunzip ref/*")
system("cat ref/*.fna > ref/viral_all.fasta")

# raw data
#data from an early COVID19 patient
dir.create('data')
options(timeout=9999) # set a higher timeout for larger downloads
download.file('https://sra-pub-sars-cov2.s3.amazonaws.com/sra-src/SRR11092062/v300043428_L02_127_1.fq.gz', 'data/viral_metagenome.fq.gz', extra = 'curl')
system('gunzip data/viral_metagenome.fq.gz')


# read query data
fq <- readDNAStringSet('data/viral_metagenome.fq', format = 'fastq')
# set up a BLAST database with viral refseq
reference <- 'ref/viral_all.fasta'
makeblastdb(reference, dbtype='nucl')
#above makes the db and below line sets up "our connection to the db" (idk)
bl <- blast(db=reference, type='blastn')

#if you look at this output using "head(fq)"
#output: DNAStringSet object length 6
#6 total rows with the width, seq, and names 
#"length(fq)"" tells you how many reads

##### BLAST in parallel #####
#uses tools in the R library parallel package 
#run a function across a cluster (you won't nec need this if you use CC)
#pass in object x (our fastq reads) and pass in the blast db and setup the cluster
parpredict <- function(x){
  return(predict(bl, x))
}

# set up a cluster
#This forks in many processes to various clusters
#he uses 16 clusters for his system - idk what would be best if you wanted to run on your local
clus <- makeCluster('16', type='FORK')
splits <- clusterSplit(clus, fq)
#above makes a list of all of the data in fq, then below passes those into parL which sends the same function to multiple clusters
p_cl <- parLapply(clus, splits, parpredict)
#run the function stop to stop and cleanup (remove?) these jobs/clusters
stopCluster(clus)
#that stuff above runs the blast search using multiple clusters, and will save the blast output table in 16 different smaller tables (1 for each cluster)

#this will moves things together?
cl <- dplyr::bind_rows(p_cl)

#### END PARALLEL #####

#shows up the summary tables from our blast output tables:
summary(cl)
#had some mismatches and such - hence the next filtering

# a bit of filtering
#only want to keep greater than 95% matched and 140 bp matched
clfilt <- cl[which(cl$Perc.Ident>=95 & cl$Alignment.Length>=140),]
#run "nrow(clfilt)" to count the rows after filtering


#### TAXONOMY ####

#the covid patient gene expression sample would have been a list of a lot of virus hits
#so this shows us what species were found in that sample

# dir.create('taxonomy')
# prepareDatabase('taxonomy/accessionTaxa.sql')

tax_db = '../db/taxonomy/'
tax_db_files = list.files(tax_db, full.names = TRUE)
nodes = tax_db_files[grepl('nodes', tax_db_files)]
names = tax_db_files[grepl('names', tax_db_files)]
accession = tax_db_files[grepl('accessionTaxa', tax_db_files)]
taxaNodes<-read.nodes.sql(nodes)
taxaNames<-read.names.sql(names)

# search for blast hit accession IDs
#make this a character vector (subject column in blast output)
accid = as.character(clfilt$SubjectID) # accession IDs of BLAST hits

#takes accession number and gets the taxonomic ID
ids<-accessionToTaxa(accid, accession)

#taxlist displays the taxonomic names from each ID #
taxlist=getTaxonomy(ids, taxaNodes, taxaNames)
cltax=cbind(clfilt,taxlist)

## visualize
#outputs a plot with family on the x axis and the hit count on the y
ggplot(cltax) +
  geom_bar(aes(x=fct_infreq(family))) +
  theme(axis.text.x = element_text(angle=90)) #rotates axis labels to read vertically

#same thing as above but with species not family
ggplot(cltax) +
  geom_bar(aes(x=fct_infreq(species))) +
  theme(axis.text.x = element_text(angle=90))