#Bioconductor ChIPPeakAnno: analysis workflow on mainly H but all

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


#Overlapping peaks and features
ol_NHP <- findOverlapsOfPeaks(grN, grH, gr8, gr5)
ol_NHP$overlappingPeaks -> NHPolpeaks
ol_NHP$peaklist -> NHPpeaks
#return how many comparisons there are 
names(NHPolpeaks)


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

#Add in gene names to your data#

library(EnsDb.Hsapiens.v86)
geneData <- toGRanges(EnsDb.Hsapiens.v86, feature="gene")
#keep the seqnames in the same style
seqlevelsStyle(geneData) <- seqlevelsStyle(grN)
#do annotation by nearest TSS
annoN <- annotatePeakInBatch(grN, AnnotationData=geneData)

#Plot the distribution of peaks around the TSS
gr1.copy <- grN
gr1.copy$score <- 1
binOverFeature(grN, gr1.copy, annotationData=geneData,
               radius=5000, nbins=10, FUN=c(sum, length),
               ylab=c("score", "count"), 
               main=c("Distribution of aggregated peak scores around TSS", 
                      "Distribution of aggregated peak numbers around TSS"))
#Only did for N as example - your deeptools one was prettier


#bar graph of peak distribution over various gene features
#had to install the TxDb (transcription db) from bioconductor
  #search annotation packages for the TxDb hg38 one
library("TxDb.Hsapiens.UCSC.hg38.knownGene")
if(require(TxDb.Hsapiens.UCSC.hg38.knownGene)){
  aCR<-assignChromosomeRegion(grH, nucleotideLevel=FALSE, 
                              precedence=c("Promoters", "immediateDownstream", 
                                           "fiveUTRs", "threeUTRs", 
                                           "Exons", "Introns"), 
                              TxDb=TxDb.Hsapiens.UCSC.hg38.knownGene)
  barplot(aCR$percentage)
}
#This wasn't nec useful for me. Saved N one as Barplot_genefeatures





