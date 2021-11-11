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


59686445-59687485
upTSSs100_5.gr__X088
PAbJUL5_MACS2broad_18Sept21_peak_33656

