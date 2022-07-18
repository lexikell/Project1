#bc_ChIPpeakanno_genesallrep2.R
#copy over the script you use from bc_ChIPpeakanno_genesall.R as you complete them for rep2

#1st you have to move the broadpeak files onto your local
#Next load up
library(ChIPpeakAnno)
setwd("/Users/lexikellington/seq/bioconductor/chippeakanno/Rep2")
#import the MACS broadpeak files
macsNr2 <- "/Users/lexikellington/seq/MACS2/JULN_MACS2broad_blacklistRemoved_1Apr22.broadPeak"
macsHr2 <- "/Users/lexikellington/seq/MACS2/JULH_MACS2broad_blacklistRemoved_1Apr22.broadPeak"
macs8r2 <- "/Users/lexikellington/seq/MACS2/JUL8_MACS2broad_blacklistRemoved_1Apr22.broadPeak"
macs5r2 <- "/Users/lexikellington/seq/MACS2/JUL5_MACS2broad_blacklistRemoved_1Apr22.broadPeak"
#make GRanges files of all
grNr2 <- toGRanges(macsN2, format="broadPeak")
grHr2 <- toGRanges(macsH2, format="broadPeak")
gr8r2 <- toGRanges(macs82, format="broadPeak")
gr5r2 <- toGRanges(macs52, format="broadPeak")

#Find overlapping peaks and save files
ol_NHP2 <- findOverlapsOfPeaks(grNr2, grHr2, gr8r2, gr5r2)
ol_NHP2$overlappingPeaks -> NHPolpeaks2
ol_NHP2$peaklist -> NHPpeaks2
#INFO: findOverlapsOfPeaks returns an object of overlappingPeaks, which contains 3 elements: 
#venn_cnt, peaklist (a list of overlapping peaks or unique peaks), and overlappingPeaks (a list of data frame consists of the annotation of all the overlapping peaks).
#look at relationships: 
#names of overlapping (to see what you can inquire about)
names(NHPolpeaks2)
#output: "gr8r2///gr5r2" "grHr2///gr5r2" "grHr2///gr8r2" "grNr2///gr5r2" "grNr2///gr8r2" "grNr2///grHr2"
#show peaks in common bt two names: 
NHPolpeaks2[["grNr2///grHr2"]]
#^or same but only first two rows: 
NHPolpeaks2[["grNr2///grHr2"]][1:2, ]
#returns the merged overlapping peaks from the peaklist object:
NHPpeaks2[["grNr2///grHr2"]]
#The peaks in peaks1 but not overlap with the other peaks
NHPpeaks2[["grNr2"]]

#Let's make a venn of the overlapping peaks with each sample
makeVennDiagram(ol_NHP2,
                NameOfPeaks=c("Normoxia", "Hypoxia", "Physioxia8", "Physioxia5"),
                fill=c(3,2,5,4),
                main = "Overlapping Peaks in Normoxia, Physioxia, and Hypoxia")
#save venn diagram counts
ol_NHP2$venn_cnt -> VennCountNHPr2
#save overlapped peaks venn count as a csv
write.csv(VennCountNHPr2, file = "VennCountNHPr2_14Jul22.csv")
#make a pie chart of what peaks overlap the other peaks
#so this really doesn't tell you much 
pie1(table(ol_NHP2$overlappingPeaks[["grNr2///grHr2"]]$overlapFeature))
#^about: inside=the peak is within the other peak, include feature=the peak is within the entire other peak

########
#Add in gene names to your data

library(EnsDb.Hsapiens.v86)
geneData <- toGRanges(EnsDb.Hsapiens.v86, feature="gene")
#keep the seqnames in the same style
seqlevelsStyle(geneData) <- seqlevelsStyle(grNr2)
#do annotation by nearest TSS
annoNr2 <- annotatePeakInBatch(grNr2, AnnotationData=geneData)
head(annoNr2)
#Pie chart: this makes a table of the "insideFeature" column and then makes a pie chart
    #ChIPpeakanno: insideFeature column reports TRUE if the query peak is either contained within an annotated feature (in our case the gene is the annotated feature), 
    #and also reports TRUE if it overlaps the end of an annotated feature.
    #"false","inside","overlapStart","overlapEnd"
    #so really, we're interested in the "overlap start" / upstream
pie1(table(annoNr2$insideFeature))
#now for the other samples:
seqlevelsStyle(geneData) <- seqlevelsStyle(grHr2)
annoHr2 <- annotatePeakInBatch(grHr2, AnnotationData=geneData)
pie1(table(annoHr2$insideFeature))
seqlevelsStyle(geneData) <- seqlevelsStyle(gr8r2)
anno8r2 <- annotatePeakInBatch(gr8r2, AnnotationData=geneData)
pie1(table(anno8r2$insideFeature))
seqlevelsStyle(geneData) <- seqlevelsStyle(gr5r2)
anno5r2 <- annotatePeakInBatch(gr5r2, AnnotationData=geneData)
pie1(table(anno5r2$insideFeature))

#now add gene IDs to all 4
library(org.Hs.eg.db)
annoIDsNr2 <- addGeneIDs(annoNr2, orgAnn="org.Hs.eg.db", 
                      feature_id_type="ensembl_gene_id",
                      IDs2Add=c("symbol"))
annoIDsHr2 <- addGeneIDs(annoHr2, orgAnn="org.Hs.eg.db", 
                       feature_id_type="ensembl_gene_id",
                       IDs2Add=c("symbol"))
annoIDs8r2 <- addGeneIDs(anno8r2, orgAnn="org.Hs.eg.db", 
                       feature_id_type="ensembl_gene_id",
                       IDs2Add=c("symbol"))
annoIDs5r2 <- addGeneIDs(anno5r2, orgAnn="org.Hs.eg.db", 
                       feature_id_type="ensembl_gene_id",
                       IDs2Add=c("symbol"))
#save this list of gene names as csv
write.csv(annoIDsNr2, file = "Nr2_annoIDs_14Jul22.csv")
write.csv(annoIDsHr2, file = "Hr2_annoIDs_14Jul22.csv")
write.csv(annoIDs8r2, file = "8r2_annoIDs_14Jul22.csv")
write.csv(annoIDs5r2, file = "5r2_annoIDs_14Jul22.csv")
#read csv into R and make df
annoIDsNr2df <- data.frame((read.csv("/Users/lexikellington/seq/bioconductor/chippeakanno/Rep2/Nr2_annoIDs_14Jul22.csv")))
annoIDsHr2df <- data.frame((read.csv("/Users/lexikellington/seq/bioconductor/chippeakanno/Rep2/Hr2_annoIDs_14Jul22.csv")))
annoIDs8r2df <- data.frame((read.csv("/Users/lexikellington/seq/bioconductor/chippeakanno/Rep2/8r2_annoIDs_14Jul22.csv")))
annoIDs5r2df <- data.frame((read.csv("/Users/lexikellington/seq/bioconductor/chippeakanno/Rep2/5r2_annoIDs_14Jul22.csv")))
#manipulate df (in drive table)
#df info
str(annoIDsNr2df)
#count 
nrow(annoIDsNr2df)
nrow(annoIDsHr2df)
nrow(annoIDs8r2df)
nrow(annoIDs5r2df)
#average/median/range of whatever column in df
mean(annoIDsNr2df$pValue)
median(annoIDsNr2df$pValue)
range(annoIDsNr2df$pValue)

#^^ something is making the N file super small
#the broadpeak file is not large - maybe the peaks are too dispersed? Something with the MACS2 output is weird
#check control and distribution? Idk 