#Bioconductor ChIPPeakAnno: analysis workflow on all 4 samples to get gene names

#moved the 4 samples (blacklist removed) files onto your local
#loaded bioconductor using their if loop on website (done from before)
#loaded the ChIPpackAnno package using the if loop on package description (done from before)

library(ChIPpeakAnno) #(loaded from before)

setwd("/Users/lexikellington/seq/bioconductor/chippeakanno")

#import the MACS broadpeak files
macsN <- "/Users/lexikellington/seq/MACS2/PAbJUL1_MACS2broad_blacklistRemoved_18Sept21.broadPeak"
macsH <- "/Users/lexikellington/seq/MACS2/PAbJUL3_MACS2broad_blacklistRemoved_18Sept21.broadPeak"
macs8 <- "/Users/lexikellington/seq/MACS2/PAbJUL5_MACS2broad_blacklistRemoved_18Sept21.broadPeak"
macs5 <- "/Users/lexikellington/seq/MACS2/PAbJUL7_MACS2broad_blacklistRemoved_18Sept21.broadPeak"
#make GRanges files of all
grN <- toGRanges(macsN, format="broadPeak")
grH <- toGRanges(macsH, format="broadPeak")
gr8 <- toGRanges(macs8, format="broadPeak")
gr5 <- toGRanges(macs5, format="broadPeak")


#Find overlapping peaks and save files
ol_NHP <- findOverlapsOfPeaks(grN, grH, gr8, gr5)
ol_NHP$overlappingPeaks -> NHPolpeaks
ol_NHP$peaklist -> NHPpeaks


#Let's make a venn of the overlapping peaks with each sample
makeVennDiagram(ol_NHP,
                NameOfPeaks=c("Normoxia", "Hypoxia", "Physioxia8", "Physioxia5"),
                fill=c(3,2,5,4),
                main = "Overlapping Peaks in Normoxia, Physioxia, and Hypoxia")
#save venn diagram counts
ol_NHP$venn_cnt -> VennCountNHP
#save overlapped peaks venn count as a csv
write.csv(VennCountNHP, file = "VennCountNHP_30Oct21.csv")

#make a pie chart of what peaks overlap the other peaks
#so this really doesn't tell you much 
pie1(table(ol_NHP$overlappingPeaks[["grN///gr5"]]$overlapFeature))
#^about: inside=the peak is within the other peak include feature=the peak is within the entire other peak

#######################

#Add in gene names to your data#

library(EnsDb.Hsapiens.v86)
geneData <- toGRanges(EnsDb.Hsapiens.v86, feature="gene")
#keep the seqnames in the same style
seqlevelsStyle(geneData) <- seqlevelsStyle(grN)
#do annotation by nearest TSS
annoN <- annotatePeakInBatch(grN, AnnotationData=geneData)
head(annoN)
#Pie chart: this makes a table of the "insideFeature" column and then makes a pie chart
pie1(table(annoN$insideFeature))
#now for the other samples:
seqlevelsStyle(geneData) <- seqlevelsStyle(grH)
annoH <- annotatePeakInBatch(grH, AnnotationData=geneData)
pie1(table(annoH$insideFeature))
seqlevelsStyle(geneData) <- seqlevelsStyle(gr8)
anno8 <- annotatePeakInBatch(gr8, AnnotationData=geneData)
pie1(table(anno8$insideFeature))
seqlevelsStyle(geneData) <- seqlevelsStyle(gr5)
anno5 <- annotatePeakInBatch(gr5, AnnotationData=geneData)
pie1(table(anno5$insideFeature))
head(geneData)

#now add gene IDs to all 4
library(org.Hs.eg.db)
annoIDsN <- addGeneIDs(annoN, orgAnn="org.Hs.eg.db", 
                      feature_id_type="ensembl_gene_id",
                      IDs2Add=c("symbol"))
annoIDsH <- addGeneIDs(annoH, orgAnn="org.Hs.eg.db", 
                       feature_id_type="ensembl_gene_id",
                       IDs2Add=c("symbol"))
annoIDs8 <- addGeneIDs(anno8, orgAnn="org.Hs.eg.db", 
                       feature_id_type="ensembl_gene_id",
                       IDs2Add=c("symbol"))
annoIDs5 <- addGeneIDs(anno5, orgAnn="org.Hs.eg.db", 
                       feature_id_type="ensembl_gene_id",
                       IDs2Add=c("symbol"))

#save this list of gene names as csv
write.csv(annoIDsN, file = "N_annoIDs_30Oct21.csv")
write.csv(annoIDsH, file = "H_annoIDs_30Oct21.csv")
write.csv(annoIDs8, file = "8_annoIDs_30Oct21.csv")
write.csv(annoIDs5, file = "5_annoIDs_30Oct21.csv")

#read csv into R and make df
annoIDsNdf <- data.frame((read.csv("/Users/lexikellington/seq/bioconductor/chippeakanno/N_annoIDs_30Oct21.csv")))
annoIDsHdf <- data.frame((read.csv("/Users/lexikellington/seq/bioconductor/chippeakanno/H_annoIDs_30Oct21.csv")))
annoIDs8df <- data.frame((read.csv("/Users/lexikellington/seq/bioconductor/chippeakanno/8_annoIDs_30Oct21.csv")))
annoIDs5df <- data.frame((read.csv("/Users/lexikellington/seq/bioconductor/chippeakanno/5_annoIDs_30Oct21.csv")))

#manipulate df (in drive table)
#df info
str(annoIDsNdf)
#count 
nrow(annoIDsNdf)
nrow(annoIDsHdf)
nrow(annoIDs8df)
nrow(annoIDs5df)
#average/median/range of whatever column in df
mean(annoIDsHdf$pValue)
median(annoIDsHdf$pValue)
range(annoIDsHdf$pValue)

#make a table of occurrences in X column
#here: count how many rows are similar in the feature column (near TSS, TES, etc)
genesFeatureN.tbl <- table(annoIDsNdf['insideFeature'])
genesFeature8.tbl <- table(annoIDs8df['insideFeature'])
genesFeature5.tbl <- table(annoIDs5df['insideFeature'])
genesFeatureH.tbl <- table(annoIDsHdf['insideFeature'])
genesFeatureN.tbl
genesFeature8.tbl
genesFeature5.tbl
genesFeatureH.tbl

#make a df with only the unique genes (listed under symbol in df)
#and save csv
genelistNdf <- subset(annoIDsNdf, !duplicated(symbol))
write.csv(genelistNdf, file = "N_genelist_30Oct21.csv")
genelistHdf <- subset(annoIDsHdf, !duplicated(symbol))
write.csv(genelistHdf, file = "H_genelist_30Oct21.csv")
genelist8df <- subset(annoIDs8df, !duplicated(symbol))
write.csv(genelist8df, file = "8_genelist_30Oct21.csv")
genelist5df <- subset(annoIDs5df, !duplicated(symbol))
write.csv(genelist5df, file = "5_genelist_30Oct21.csv")
nrow(genelistNdf)
nrow(genelist8df)
nrow(genelist5df)
nrow(genelistHdf)

