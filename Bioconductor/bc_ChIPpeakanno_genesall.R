#Bioconductor ChIPPeakAnno: analysis workflow on all 4 samples to get gene names
#USE THIS ONE

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
#INFO: findOverlapsOfPeaks returns an object of overlappingPeaks, which contains there elements: 
#venn_cnt, peaklist (a list of overlapping peaks or unique peaks), and overlappingPeaks (a list of data frame consists of the annotation of all the overlapping peaks).
#look at relationships: 
#names of overlapping: #output: "gr8///gr5" "grH///gr5" "grH///gr8" "grN///gr5" "grN///gr8" "grN///grH"
names(NHPolpeaks)  
#show peaks in common bt two names: 
NHPolpeaks[["grN///grH"]]
#^or same but only first two rows: 
NHPolpeaks[["grN///grH"]][1:2, ]
#returns the merged overlapping peaks from the peaklist object:
NHPpeaks[["grN///grH"]]
#The peaks in peaks1 but not overlap with the other peaks
NHPpeaks[["grN"]]




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
#OR 
#count how many of each variable within a specific column
annoIDsHdf %>% count(insideFeature)


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


#make df with no NA gene hits
#count total rows
nrow(annoIDsNdf) -> A
#count NA values (to check later)
sum(is.na(annoIDsNdf$symbol)) -> B
#make new df omitting NA rows in gene 
annoIDsNdf_hits <- na.omit(annoIDsNdf, c("symbol"))
nrow(annoIDsNdf_hits)
#make sure your predicted NA removed list matches your actual 
A-B 
#percent of peaks that were NA
B/A
#make other samples: 
nrow(annoIDsHdf) -> A
sum(is.na(annoIDsHdf$symbol)) -> B
annoIDsHdf_hits <- na.omit(annoIDsHdf, c("symbol"))
nrow(annoIDsHdf_hits)
A-B
B/A
nrow(annoIDs8df) -> A
sum(is.na(annoIDs8df$symbol)) -> B
annoIDs8df_hits <- na.omit(annoIDs8df, c("symbol"))
nrow(annoIDs8df_hits)
A-B
nrow(annoIDs5df) -> A
sum(is.na(annoIDs5df$symbol)) -> B
annoIDs5df_hits <- na.omit(annoIDs5df, c("symbol"))
nrow(annoIDs5df_hits)
A-B

install.packages("tidyverse")
library(dplyr)
#make new df w/ only "upstream" values in "insideFeature" column 
#annoIDsNdf_upTSS <- subset(annoIDsNdf_hits, insideFeature == upstream)
#OR using dyplr:
annoIDsNdf_upTSS <- filter(annoIDsNdf_hits, insideFeature == "upstream")
nrow(annoIDsNdf_upTSS)
#count how many of each variable within a specific column
annoIDsNdf_hits %>% count(insideFeature)
#other samples
#H
annoIDsHdf_upTSS <- filter(annoIDsHdf_hits, insideFeature == "upstream")
nrow(annoIDsHdf_upTSS)
annoIDsHdf_hits %>% count(insideFeature)
#8
annoIDs8df_upTSS <- filter(annoIDs8df_hits, insideFeature == "upstream")
nrow(annoIDs8df_upTSS)
annoIDs8df_hits %>% count(insideFeature)
#5
annoIDs5df_upTSS <- filter(annoIDs5df_hits, insideFeature == "upstream")
nrow(annoIDs5df_upTSS)
annoIDs5df_hits %>% count(insideFeature)

#how many gene hits are >=8kb upTSS?
sum(annoIDs5df_upTSS$distancetoFeature >= -8000)  #output: 7557
#make a new df with upTSS gene hits but only >= 8kb upstream TSS
annoIDsNdf_upTSS$distancetoFeature>=-8000 -> upTSS8kb_N  #makes a T/F vector
annoIDsNdf_upTSS8kb <- subset(annoIDsNdf_upTSS, upTSS8kb_N)
annoIDsNdf_upTSS8kb
nrow(annoIDsNdf_upTSS8kb)

annoIDsHdf_upTSS$distancetoFeature>=-8000 -> upTSS8kb_H
annoIDsHdf_upTSS8kb <- subset(annoIDsHdf_upTSS, upTSS8kb_H)
annoIDsHdf_upTSS8kb
nrow(annoIDsHdf_upTSS8kb)

annoIDs8df_upTSS$distancetoFeature>=-8000 -> upTSS8kb_8
annoIDs8df_upTSS8kb <- subset(annoIDs8df_upTSS, upTSS8kb_8)
annoIDs8df_upTSS8kb
nrow(annoIDs8df_upTSS8kb)

annoIDs5df_upTSS$distancetoFeature >= -8000 -> upTSS8kb_5
annoIDs5df_upTSS8kb <- subset(annoIDs5df_upTSS, upTSS8kb_5)
annoIDs5df_upTSS8kb
nrow(annoIDs5df_upTSS8kb)



#make a new subset with only gene names with a score >= 200
annoIDsNdf_upTSS$score >= 200 -> ScoreN200
annoIDsNdf_upTSSs200 <- subset(annoIDsNdf_upTSS, ScoreN200)
annoIDsNdf_upTSSs200
nrow(annoIDsNdf_upTSSs200)
annoIDsHdf_upTSS$score >= 200 -> ScoreH200
annoIDsHdf_upTSSs200 <- subset(annoIDsHdf_upTSS, ScoreH200)
annoIDsHdf_upTSSs200
nrow(annoIDsHdf_upTSSs200)
annoIDs8df_upTSS$score >= 200 -> Score8200
annoIDs8df_upTSSs200 <- subset(annoIDs8df_upTSS, Score8200)
annoIDs8df_upTSSs200
nrow(annoIDs8df_upTSSs200)
annoIDs5df_upTSS$score >= 200 -> Score5200
annoIDs5df_upTSSs200 <- subset(annoIDs5df_upTSS, Score5200)
annoIDs5df_upTSSs200
nrow(annoIDs5df_upTSSs200)

#make a new subset with only gene names with a score >= 100
annoIDsNdf_upTSS$score >= 100 -> ScoreN100
annoIDsNdf_upTSSs100 <- subset(annoIDsNdf_upTSS, ScoreN100)
nrow(annoIDsNdf_upTSSs100)
annoIDsHdf_upTSS$score >= 100 -> ScoreH100
annoIDsHdf_upTSSs100 <- subset(annoIDsHdf_upTSS, ScoreH100)
nrow(annoIDsHdf_upTSSs100)
annoIDs8df_upTSS$score >= 100 -> Score8100
annoIDs8df_upTSSs100 <- subset(annoIDs8df_upTSS, Score8100)
nrow(annoIDs8df_upTSSs100)
annoIDs5df_upTSS$score >= 100 -> Score5100
annoIDs5df_upTSSs100 <- subset(annoIDs5df_upTSS, Score5100)
nrow(annoIDs5df_upTSSs100)

