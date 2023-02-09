#bc_chipseeker.R
#ChIPseeker from Bioconductor
#
#Input either peak file (broadpeak on local?) or granges (from chippeakanno?)
#HERE Let's use the original Peak file but make a smaller "promoter" area of interest (-2,000 - 500)
#OVERALL: not more helpful. Doesn't show anything new. I like my current combo of my own graphs and using deeptools

#bc_chipseeker.R

#ChIPseeker from Bioconductor
#
#Input either peak file (broadpeak on local?) or granges (from chippeakanno?)

if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("ChIPseeker")

a#Next load up
library(ChIPseeker)
library(TxDb.Hsapiens.UCSC.hg19.knownGene)
txdb <- TxDb.Hsapiens.UCSC.hg19.knownGene
library(clusterProfiler)
setwd("/Users/lexikellington/seq/bioconductor/chipseeker")
#import the MACS broadpeak files
macsN <- "/Users/lexikellington/seq/MACS2/PAbJUL1_MACS2broad_blacklistRemoved_18Sept21.broadPeak"

#annotate peak from peakfile
peakAnno <- annotatePeak(macsN, tssRegion=c(-2000, 500),
                         TxDb=txdb, annoDb="org.Hs.eg.db")

#make circle graph of gene annotation
plotAnnoPie(peakAnno)
#make bar graph of above
plotAnnoBar(peakAnno)
vennpie(peakAnno)
#Upset plot of genic dis
install.packages("UpSetR")
install.packages("ggupset")
upsetplot(peakAnno)
install.packages("ggimage")
upsetplot(peakAnno, vennpie=TRUE)
#Dis relative to TSS
#You show this better with deeptools where there is a y axis for amount
plotDistToTSS(peakAnno,
        title="Distribution of transcription factor-binding loci\nrelative to TSS")

#^^ I've shown all of these in better ways though....
#The upset here doesn't even show better than the adjusted circle graph you already made...
#