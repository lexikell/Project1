#bc_ChIPpeakanno_compare.R

#make Granges from the df of just the TSS peaks w/ scores <=100 (annoIDsNdf_upTSSs100)
#1st: 
#make a new df from annoIDsNdf_upTSSs100 keeping only the columns for BED format
annoIDsNdf_upTSSs100 %>% select(seqnames, start, end, peak, score, strand, signalValue, pValue, qValue) -> upTSSs100_N.broadpeak
upTSSs100_N.broadpeak %>% 
  rename(
    chrom = seqnames,
    chromStart = start,
    chromEnd = end,
    name = peak,
  )
annoIDsHdf_upTSSs100 %>% select(seqnames, start, end, peak, score, strand, signalValue, pValue, qValue) -> upTSSs100_H.broadpeak
upTSSs100_H.broadpeak %>% 
  rename(
    chrom = seqnames,
    chromStart = start,
    chromEnd = end,
    name = peak,
  )
annoIDs8df_upTSSs100 %>% select(seqnames, start, end, peak, score, strand, signalValue, pValue, qValue) -> upTSSs100_8.broadpeak
upTSSs100_8.broadpeak %>% 
  rename(
    chrom = seqnames,
    chromStart = start,
    chromEnd = end,
    name = peak,
  )
annoIDs5df_upTSSs100 %>% select(seqnames, start, end, peak, score, strand, signalValue, pValue, qValue) -> upTSSs100_5.broadpeak
upTSSs100_5.broadpeak %>% 
  rename(
    chrom = seqnames,
    chromStart = start,
    chromEnd = end,
    name = peak,
  )

#2nd: turn those df into grange files using toGRanges
#make GRanges files of all
upTSSs100_N.gr <- toGRanges(upTSSs100_N.broadpeak, format="broadPeak")
upTSSs100_H.gr <- toGRanges(upTSSs100_H.broadpeak, format="broadPeak")
upTSSs100_8.gr <- toGRanges(upTSSs100_8.broadpeak, format="broadPeak")
upTSSs100_5.gr <- toGRanges(upTSSs100_5.broadpeak, format="broadPeak")
#ERROR: "duplicated or NA names found. Rename all the names by numbers." #still worked but noted

#3rd: find overlaps in these new granges (new grange is: -TSS and sig pvalue)
#Find overlapping peaks and save files
ol_NHP_upTSSs100 <- findOverlapsOfPeaks(upTSSs100_N.gr, upTSSs100_H.gr, upTSSs100_8.gr, upTSSs100_5.gr)
ol_NHP_upTSSs100$overlappingPeaks -> NHP_upTSSs100_olpeaks
ol_NHP_upTSSs100$peaklist -> NHP_upTSSs100_peaks

#4th: venn diagram plot
makeVennDiagram(ol_NHP_upTSSs100,
                NameOfPeaks=c("Normoxia", "Hypoxia", "Physioxia8", "Physioxia5"),
                fill=c(3,2,5,4),
                main = "Overlapping Peaks upstream of TSS in Normoxia, Physioxia, and Hypoxia")
#save venn diagram counts
ol_NHP_upTSSs100$venn_cnt -> VennCountNHP_upTSSs100
#save overlapped peaks venn count as a csv
write.csv(VennCountNHP_upTSSs100, file = "VennCountNHPupTSSs100_10Nov21.csv")
#annotate
#show peaks in common bt two names: 
NHP_upTSSs100_peaks[["upTSSs100_8.gr///upTSSs100_5.gr"]]
#then locate the common one in the olpeaks to get peak name to search file for gene name
NHP_upTSSs100_peaks[["upTSSs100_8.gr///upTSSs100_5.gr"]]
#search peak name in gene list of that sample
grep("59686445", upTSSs100_8.gr)  #output: 28

upTSSs100_8.gr[28, ] -> promoter
data.frame(promoter)
grep("59686445", upTSSs100_8.broadpeak) #output:4 THIS IS NOT THE ROW IDK WHAT THIS IS
upTSSs100_8.broadpeak[2, ]
#outputs:
#59686445-59687485
#upTSSs100_5.gr__X088
#PAbJUL5_MACS2broad_18Sept21_peak_33656

#NEW DATASET:
#see overlapping peaks of only peaks -8kb--1 TSS
#1st: 
#make a new df from annoIDsNdf_upTSS8kb keeping only the columns for Broadpeak format
annoIDsNdf_upTSS8kb %>% select(seqnames, start, end, peak, score, strand, signalValue, pValue, qValue) -> upTSS8kb_N.broadpeak
upTSS8kb_N.broadpeak %>% 
  rename(
    chrom = seqnames,
    chromStart = start,
    chromEnd = end,
    name = peak,
  )
annoIDsHdf_upTSS8kb %>% select(seqnames, start, end, peak, score, strand, signalValue, pValue, qValue) -> upTSS8kb_H.broadpeak
upTSS8kb_H.broadpeak %>% 
  rename(
    chrom = seqnames,
    chromStart = start,
    chromEnd = end,
    name = peak,
  )
annoIDs8df_upTSS8kb %>% select(seqnames, start, end, peak, score, strand, signalValue, pValue, qValue) -> upTSS8kb_8.broadpeak
upTSS8kb_8.broadpeak %>% 
  rename(
    chrom = seqnames,
    chromStart = start,
    chromEnd = end,
    name = peak,
  )
annoIDs5df_upTSS8kb %>% select(seqnames, start, end, peak, score, strand, signalValue, pValue, qValue) -> upTSS8kb_5.broadpeak
upTSS8kb_5.broadpeak %>% 
  rename(
    chrom = seqnames,
    chromStart = start,
    chromEnd = end,
    name = peak,
  )

#2nd: turn those df into grange files using toGRanges
#make GRanges files of all
upTSS8kb_Ngr <- toGRanges(upTSS8kb_N.broadpeak, format="broadPeak")
upTSS8kb_Hgr <- toGRanges(upTSS8kb_H.broadpeak, format="broadPeak")
upTSS8kb_8gr <- toGRanges(upTSS8kb_8.broadpeak, format="broadPeak")
upTSS8kb_5gr <- toGRanges(upTSS8kb_5.broadpeak, format="broadPeak")

#3rd
#Find overlapping peaks and save files
#ERROR keeps occurring with findOverlapsOfPeaks here:
ol_NHP_upTSS8kb <- findOverlapsOfPeaks(upTSS8kb_Ngr, upTSS8kb_Hgr, upTSS8kb_8gr, upTSS8kb_5gr)
#ERROR: "Inputs contains duplicated ranges"
#remove N and it works...
ol_NHP_upTSS8kb <- findOverlapsOfPeaks(upTSS8kb_Hgr, upTSS8kb_8gr, upTSS8kb_5gr)
#ONLINE FORUM HELP!:
#duplicates will make this error. To check for duplicates: 
df <- data.frame(upTSS8kb_Ngr)
df[duplicated(df), ]
# To remove duplicates, simply:
upTSS8kb_Ngr2 <- unique(upTSS8kb_Ngr)
#and now try with new gr:
ol_NHP_upTSS8kb <- findOverlapsOfPeaks(upTSS8kb_Ngr2, upTSS8kb_Hgr, upTSS8kb_8gr, upTSS8kb_5gr)
#IT WORKED! NO ERROR! ON WITH THE SHOW!:
ol_NHP_upTSS8kb$overlappingPeaks -> NHP_upTSS8kb_olpeaks
ol_NHP_upTSS8kb$peaklist -> NHP_upTSS8kb_peaks

#4th: venn diagram plot
makeVennDiagram(ol_NHP_upTSS8kb,
                NameOfPeaks=c("Normoxia", "Hypoxia", "Physioxia8", "Physioxia5"),
                fill=c(3,2,5,4),
                main = "Overlapping Peaks 8Kb upstream of TSS in Normoxia, Physioxia, and Hypoxia")
#save venn diagram counts
ol_NHP_upTSS8kb$venn_cnt -> VennCountNHP_upTSS8kb
#save overlapped peaks venn count as a csv
write.csv(VennCountNHP_upTSS8kb, file = "VennCountNHPupTSS8kb_10Nov21.csv")
#annotate
#show peaks in common bt two names: 
NHP_upTSS8kb_peaks[["upTSS8kb_8gr///upTSS8kb_5gr"]]
#then locate the common one in the olpeaks to get peak name to search file for gene name
NHP_upTSS8kb_olpeaks[["upTSS8kb_8gr///upTSS8kb_5gr"]]

##Get gene names from the overlapping peaks list:
#save the comparison metatable as a df
NHPup8kb_peaks_8vs5.df <- data.frame(NHP_upTSS8kb_peaks[["upTSS8kb_8gr///upTSS8kb_5gr"]])
NHPup8kb_olpeaks_8vs5.df <- data.frame(NHP_upTSS8kb_olpeaks[["upTSS8kb_8gr///upTSS8kb_5gr"]])
#save "in common" list of ranges (start and end NT) which matches the venn:
NHP_upTSS8kb_peaks[["upTSS8kb_8gr///upTSS8kb_5gr"]]@ranges -> NHP_up8kb_peaks_8vs5
#then make this a df to search
NHPup8kb_peaksSE_8vs5.df <- data.frame(NHP_up8kb_peaks_8vs5)
#Now we can compare the start/end positions to the "annoIDs8df" start/end to get gene names
NHPup8kb_peaksSE_8vs5genes.df <- annoIDs8df %>% filter(start %in% NHPup8kb_peaksSE_8vs5.df$start)

#take the olpeaks df and turn into BED (start/end; p/qvalues)
#and then addgeneids 
#or for peaks list (not olpeaks?)

######
#OR just use the annoIDs8df_upTSS8kb df and minus the other samples?
#shorter df list to include only scores above 100 (which is equal to qvalue I think)
annoIDs8df_upTSS8kb$score >= 100 -> Score100_up8kb8
annoIDs8df_upTSS8kbs100 <- subset(annoIDs8df_upTSS8kb, Score100_up8kb8)
nrow(annoIDs8df_upTSS8kbs100)
annoIDsNdf_upTSS8kb$score >= 100 -> Score100_up8kbN
annoIDsNdf_upTSS8kbs100 <- subset(annoIDsNdf_upTSS8kb, Score100_up8kbN)
nrow(annoIDsNdf_upTSS8kbs100)
annoIDsHdf_upTSS8kb$score >= 100 -> Score100_up8kbH
annoIDsHdf_upTSS8kbs100 <- subset(annoIDsHdf_upTSS8kb, Score100_up8kbH)
nrow(annoIDsHdf_upTSS8kbs100)
annoIDs5df_upTSS8kb$score >= 100 -> Score100_up8kb5
annoIDs5df_upTSS8kbs100 <- subset(annoIDs5df_upTSS8kb, Score100_up8kb5)
nrow(annoIDs5df_upTSS8kbs100)


#subset df to include only pvalues above 4 (cuttoff from nature 2021 paper)
annoIDs8df_upTSS8kb$pValue >= 4 -> pvalue4_up8kb8
annoIDs8df_upTSS8kbp4 <- subset(annoIDs8df_upTSS8kb, pvalue4_up8kb8)
nrow(annoIDs8df_upTSS8kbp4)
annoIDsNdf_upTSS8kb$score >= 100 -> Score100_up8kbN
annoIDsNdf_upTSS8kbp4 <- subset(annoIDsNdf_upTSS8kb, Score100_up8kbN)
nrow(annoIDsNdf_upTSS8kbp4)
annoIDsHdf_upTSS8kb$score >= 100 -> Score100_up8kbH
annoIDsHdf_upTSS8kbp4 <- subset(annoIDsHdf_upTSS8kb, Score100_up8kbH)
nrow(annoIDsHdf_upTSS8kbp4)
annoIDs5df_upTSS8kb$score >= 100 -> Score100_up8kb5
annoIDs5df_upTSS8kbp4 <- subset(annoIDs5df_upTSS8kb, Score100_up8kb5)
nrow(annoIDs5df_upTSS8kbp4)