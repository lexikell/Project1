#bc_chipseeker.R
#ChIPseeker from Bioconductor
#
#Input either peak file (broadpeak on local?) or granges (from chippeakanno?)

if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("ChIPseeker")

#Next load up
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
