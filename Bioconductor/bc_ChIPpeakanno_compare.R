#bc_ChIPpeakanno_compare.R

#make Granges from the df of just the TSS peaks w/ scores <=100 (annoIDsNdf_upTSSs100)
#1st: 
#make a new df from annoIDsNdf_upTSSs100 keeping only the columns for BED format
annoIDsNdf_upTSSs100 %>% select(seqnames, start, end, peak, score, strand, )

#2nd: turn those df into grange files using toGRanges
#make GRanges files of all
grN <- toGRanges(macsN, format="BED")
grH <- toGRanges(macsH, format="broadPeak")
gr8 <- toGRanges(macs8, format="broadPeak")
gr5 <- toGRanges(macs5, format="broadPeak")

#3rd: find overlaps in these new granges (new grange is: -TSS and sig pvalue)
#4th: venn diagram plot

#THIS for lab meeting AND possibly Gaelans? 