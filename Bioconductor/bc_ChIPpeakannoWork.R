#Bioconductor ChIPPeakAnno: analysis workflow

#moved the hypoxic sample (PAb3) blacklist removed file onto your local
#loaded bioconductor using their if loop on website
#loaded the ChIPpackAnno package using the if loop on package description

library(ChIPpeakAnno)

setwd("/Users/lexikellington/seq/bioconductor/chippeakanno")

#import the MACS output broadpeak file
macsH <- "/Users/lexikellington/seq/MACS2/PAbJUL3_MACS2broad_blacklistRemoved_18Sept21.broadPeak"
grH <- toGRanges(macsH, format="broadPeak")
grH[1:2]

#Let's make a venn of the similar peaks in the N GRanges you made before and this H GRange
ol_NH <- findOverlapsOfPeaks(macsOutput, grH)
makeVennDiagram(ol_NH,
                NameOfPeaks=c("Normoxia", "Hypoxia"),
                fill=c("#009E73", "#F0E442"), # circle fill color
                col=c("#D55E00", "#0072B2"), #circle border color
                cat.col=c("#D55E00", "#0072B2"))

