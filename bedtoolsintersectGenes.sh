#!/bin/bash
#SBATCH --account=def-juniacke
#SBATCH --job-name=intersectgenes
#SBATCH --ntasks-per-node=5
#SBATCH --time=0-00:25:00
#SBATCH --mem-per-cpu=1G
#SBATCH --output=promoterBAM.%J.out
#SBATCH --error=promoterBAM.%J.err

module load StdEnv/2020
#you had these before but maybe they're not nec? idk 
#module load nixpkgs/16.09  gcc/7.3.0
#module load nixpkgs/16.09  intel/2018.3

module load bedtools/2.30.0

#GOAL: filter the broadpeak macs2 output file to get only the peaks around TSSs

#First, move files from local to CC just on terminal seperate from job 
#NOTE: "annoIDs5df_up5000down1000.bed" are comma deliminted and "annoIDs5df_up5000down1000BED.bed" are tab deliminted (use tab for everything)
#scp /Users/lexikellington/seq/annoIDsHdf_up5000down1000BED.bed akelling@cedar.computecanada.ca:/home/akelling/projects/def-juniacke/akelling/project_202107/30_bioconductor/rep1/chippeakanno

genesbedN=/home/akelling/projects/def-juniacke/akelling/project_202107/30_bioconductor/rep1/chippeakanno/annoIDsNdf_up5000down1000.bed
genesbed5=/home/akelling/projects/def-juniacke/akelling/project_202107/30_bioconductor/rep1/chippeakanno/annoIDs5df_up5000down1000.bed
genesbedH=/home/akelling/projects/def-juniacke/akelling/project_202107/30_bioconductor/rep1/chippeakanno/annoIDsHdf_up5000down1000.bed

bamdir=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21
workdir=/home/akelling/projects/def-juniacke/akelling/project_202107/30_bioconductor/rep1/chippeakanno

#now let's filter the macs2 Broadpeak file by the bed file that includes only the peaks that are around TSS (-5000 - +1000)
#WAIT NO lets filter the original BAM file, not the MACS2 bed file 
bedtools intersect -wa -abam $bamdir/PAbJUL1_18Sept21.bam -b $genesbedN > annoIDsNdf_up5000down1000.bam
bedtools intersect -wa -abam $bamdir/PAbJUL7_18Sept21.bam -b $genesbed5 > annoIDs5df_up5000down1000.bam
bedtools intersect -wa -abam $bamdir/PAbJUL3_18Sept21.bam -b $genesbedH > annoIDsHdf_up5000down1000.bam

#ERROR
#I think your bed files have headers when they shouldn't
#let's try to delete the first line 
#sed '1d' annoIDsHdf_up5000down1000BED.bed > annoIDsHdf_up5000down1000.bed
#ERROR
#also have to delete any NA lines 
#sed -i "/NA/d" annoIDsHdf_up5000down1000.bed
#OKAY BUT I don't think this will actually be good for cmatrix to compare to a whole genome
    #I think these regions are so small that this won't actually work the way I think it will BUT maybe it will filter the bams okay...I have to think


#for compute matrix downstream, try to avoid SES normalization (apparently not great for broadmarks) - instead use total read count(?)

