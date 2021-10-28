#from "R Bioinformatics rBLAST" Rob H YouTube

#install bioconductor program rBLAST from github and load in various bc packges that comes with that
devtools::install_github("mhahsler/rBLAST")
library(rBLAST)
library(ggplot)

#his examples use a cholera genome 
#Here we download the genome, unzip it, and then use the readDNA function in BioStrings bioconductor package
download.file('ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/bacteria/Vibrio_cholerae/representative/GCF_000829215.1_ASM82921v1/GCF_000829215.1_ASM82921v1_genomic.fna.gz',
              'cholera.fna.gz')
system('gunzip cholera.fna.gz')
genome = readDNAStringSet('cholera.fna')
genome
#^looks at it the genome stringset object you made (here it has two chr with the NT lenght (width))

#next download the gene sequences for the cholera genome and reads it into biostringset
download.file('https://raw.githubusercontent.com/developing-bioinformatics/bioinformatics/master/data/ctxAB.fasta',
              'ctxAB.fasta')
query = readDNAStringSet('ctxAB.fasta')
#If you look at this, it will show 117 gene sequences shown in a table with width, sequence, and the name of the gene in the fourth and last column

# watch for ambiguous base calls 
#otherwise BLAST won't run in the below ones (doesn't show how to troubleshoot)

# setting up BLAST:

#variable with the path to our reference db
reference = 'cholera.fna'

#R function to make a compatible db. Here it makes a NT db, but you can also make a protein db 
makeblastdb(reference, dbtype='nucl')
#^ will have an output of the db stats you just made (the name and pwd, typem file size etc) his was very small

# run BLAST query:

#blast function using the reference db you just made and using the "blastn" function
bl <- blast(db=reference, type='blastn')
#if you run bl, it will give the pwd, the db you're looking at (2 seq, total bases), date, etc
bl
#next we define an object to "catch our data" and run the BLAST search:
#predict is the search, bl is our db that we made, and query is our gene list we defined from earlier
cl <- predict(bl, query)
cl
#^ if you look at this output, you'll see a table with the normal BLAST stats: queryID, subjectID (gene), %identity, length, etc

#visualize your data:
#position of matches along the genome: graph the "s start" column (where is the genome the match started)
#kernel: this makes it fast idk at 3000 positions (idk)
#xlim is the chr length (idk)
ggplot(cl) +
  geom_density(aes(x=S.start), kernel='rectangular', n=3000) +
  xlim(0, 2936971) + 
  theme_linedraw()

#I don't particularly like this graph for my uses: I'm going to try his other tutorial 