#!/bin/bash
#SBATCH --account=def-juniacke
#SBATCH --job-name=merge
#SBATCH --ntasks-per-node=8
#SBATCH --time=0-00:60:00
#SBATCH --mem-per-cpu=2G
#SBATCH --output=merge.%J.out
#SBATCH --error=merge.%J.err

module load StdEnv/2020
#you had these before but maybe they're not nec? idk 
#module load nixpkgs/16.09  gcc/7.3.0
#module load nixpkgs/16.09  intel/2018.3

module load bedtools/2.30.0

#use intersect to find the overlap bt RNACentral and your data 

REP1_5=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/macs2/PAbJUL7_MACS2broad_18Sept21_peaks.broadPeak
REP2_5=/home/akelling/projects/def-juniacke/akelling/project_202107/20_aligned/macs2/JUL5_MACS2broad_1Apr22_peaks.broadPeak
merge5=/home/akelling/projects/def-juniacke/akelling/project_202107/20_aligned/merge/JUL5_merge.broadpeak
bedtools intersect -wa -a $REP1_5 -b $REP2_5 > $merge5

REP1_5=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/macs2/PAbJUL7_MACS2broad_18Sept21_peaks.broadPeak
REP2_5=/home/akelling/projects/def-juniacke/akelling/project_202107/20_aligned/macs2/JUL5_MACS2broad_1Apr22_peaks.broadPeak
merge5=/home/akelling/projects/def-juniacke/akelling/project_202107/20_aligned/merge/JUL5_merge.broadpeak
bedtools intersect -wa -a $REP1_5 -b $REP2_5 > $merge5



REP1N=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/macs2/PAbJUL1_MACS2broad_18Sept21_peaks.broadPeak
REP2N=/home/akelling/projects/def-juniacke/akelling/project_202107/20_aligned/macs2/JULN_MACS2broad_1Apr22_peaks.broadPeak
mergeN=/home/akelling/projects/def-juniacke/akelling/project_202107/20_aligned/merge/JULN_merge.broadpeak
bedtools intersect -wa -a $REP1N -b $REP2N > $mergeN

REP1H=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/macs2/PAbJUL3_MACS2broad_18Sept21_peaks.broadPeak
REP2H=/home/akelling/projects/def-juniacke/akelling/project_202107/20_aligned/macs2/JULH_MACS2broad_1Apr22_peaks.broadPeak
mergeH=/home/akelling/projects/def-juniacke/akelling/project_202107/20_aligned/merge/JULH_merge.broadpeak
bedtools intersect -wa -a $REP1H -b $REP2H > $mergeH

#OH RIGHT the normoxic rep2 macs2 files is no good! So don't use this merged file for the peak images
#just use the original macs2 files not the merged ones 

#this worked but I want bam not bed (to convert to bw) 

mergeH=/home/akelling/projects/def-juniacke/akelling/project_202107/20_aligned/merge/JULH_merge.broadpeak

bedToBam -i mergeH -g human.hg18.genome > JULH_merge.bam
