#Bioconductor ChIPPeakAnno: Quick Start

#moved the first PAb1 blacklist removed file onto your local
#loaded bioconductor using their if loop on website
#loaded the ChIPpackAnno package using the if loop on package description

library(ChIPpeakAnno)

setwd("/Users/lexikellington/seq/bioconductor/chippeakanno")

## import the MACS output 
#STEP1
macs <- "/Users/lexikellington/seq/MACS2/PAbJUL1_MACS2broad_blacklistRemoved_18Sept21.broadPeak"
macsOutput <- toGRanges(macs, format="broadPeak")

#prepare annotation data with toGRanges
#STEP2
library(EnsDb.Hsapiens.v86)
annoData <- toGRanges(EnsDb.Hsapiens.v86)
annoData[1:2]

#annotate peaks with annotatepeakinbatch
#STEP3
## keep the seqnames in the same style
seqlevelsStyle(macsOutput) <- seqlevelsStyle(annoData)
## do annotation by nearest TSS
anno <- annotatePeakInBatch(macsOutput, AnnotationData=annoData)
anno[1:2]
#make a pie chart of the anno data - this is data that aligned with the hg38 genome
#this makes a table of the "insideFeature" column and then makes a pie chart from those values
pie1(table(anno$insideFeature))

#now addgeneIDs
library(org.Hs.eg.db)
annoIDs <- addGeneIDs(anno, orgAnn="org.Hs.eg.db", 
                   feature_id_type="ensembl_gene_id",
                   IDs2Add=c("symbol"))
head(annoIDs)

#save this list of gene names 
write.csv(annoIDs, file = "PAb1_annoIDs.csv")
#turn that csv into a dataframe to manipulate
#upload into R and then make df
annoIDscsv <- read.csv("/Users/lexikellington/seq/bioconductor/chippeakanno/PAb1_annoIDs.csv")
annoIDsdf <- data.frame(annoIDscsv)
head(annoIDsdf)
nrow(annoIDsdf)
#make a table of occurrences in X column
#here: count how many rows are similar in the feature column (near TSS, TES, etc)
genesFeature.tbl <- table(annoIDsdf['insideFeature'])
genesFeature.tbl

#make a df with only the unique genes (listed under symbol in df)
annoUniquegenesdf <- subset(annoIDsdf, !duplicated(symbol))
#save this list of gene names 
write.csv(annoUniquegenesdf, file = "PAb1_annoUniquegenes_30Oct21.csv")
##LOOK AT DF##
head(annoUniquegenesdf)
#how many rows in df
nrow(annoUniquegenesdf)
#show info: what file is this? How many observations total in X number of columns (variables)
#here: 17220 obs (rows) in 20 columns
str(annoUniquegenesdf)
#NOTE: we DO NOT want to use the unique gene data to count the number of genes next to features,
# as there may be multiple peaks across a single gene, and this list discards all of those but one








#THIS is from the brief quick start before the detailed tutorial. 
#I added the longer quick start since then

## annotate the peaks with precompiled ensembl annotation
#data(TSS.human.GRCh38)
#macs.anno <- annotatePeakInBatch(macsOutput, AnnotationData=TSS.human.GRCh38)

## add gene symbols
#library(org.Hs.eg.db)
#macs.anno <- addGeneIDs(annotatedPeak=macs.anno, 
#                        orgAnn="org.Hs.eg.db", 
#                        IDs2Add="symbol")

#if(interactive()){## annotate the peaks with UCSC annotation
#  library(GenomicFeatures)
#  library(TxDb.Hsapiens.UCSC.hg38.knownGene)
#  ucsc.hg38.knownGene <- genes(TxDb.Hsapiens.UCSC.hg38.knownGene)
#  macs.anno <- annotatePeakInBatch(macsOutput, 
#                                   AnnotationData=ucsc.hg38.knownGene)
#  macs.anno.IDs <- addGeneIDs(annotatedPeak=macs.anno, 
#                          orgAnn="org.Hs.eg.db", 
#                          feature_id_type="entrez_id",
#                          IDs2Add="symbol")
#}