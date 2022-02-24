#bc_ChIPpeakanno_genome.R

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("TxDb.Hsapiens.UCSC.hg19.knownGene")
library(TxDb.Hsapiens.UCSC.hg19.knownGene)

#this works great
peaks <- GRangesList(Normoxia=grN,
                     Hypoxia=grH)
genomicElementDistribution(peaks, 
                           TxDb = TxDb.Hsapiens.UCSC.hg19.knownGene,
                           promoterRegion=c(upstream=2000, downstream=500),
                           geneDownstream=c(upstream=0, downstream=2000))


out <- genomicElementDistribution(NHPpeaks, 
                                  TxDb = TxDb.Hsapiens.UCSC.hg19.knownGene,
                                  promoterRegion=c(upstream=2000, downstream=500),
                                  geneDownstream=c(upstream=0, downstream=2000),
                                  promoterLevel=list(
                                    # from 5' -> 3', fixed precedence 3' -> 5'
                                    breaks = c(-2000, -1000, -500, 0, 500),
                                    labels = c("upstream 1-2Kb", "upstream 0.5-1Kb", 
                                               "upstream <500b", "TSS - 500b"),
                                    colors = c("#FFE5CC", "#FFCA99", 
                                               "#FFAD65", "#FF8E32")))

