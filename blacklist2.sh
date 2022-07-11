#!/bin/bash
#SBATCH --account=def-juniacke
#SBATCH --job-name=blacklist
#SBATCH --ntasks-per-node=8
#SBATCH --time=0-00:20:00
#SBATCH --mem-per-cpu=1G
#SBATCH --output=Blacklist.%J.out
#SBATCH --error=Blacklist.%J.err

module load StdEnv/2020
module load nixpkgs/16.09  gcc/7.3.0
module load nixpkgs/16.09  intel/2018.3

module load bedtools/2.29.2

#remove the blacklist regions
#save output in new dir in macs2

ID="1Apr22"
WORKDIR=/home/akelling/projects/def-juniacke/akelling/project_202107/20_aligned/macs2
SAMPLE="JULH"

blacklist=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/blacklist/hg38-blacklist.bed
sample=$WORKDIR/$SAMPLE"_MACS2broad_"$ID"_peaks.broadPeak"
name="$SAMPLE""_MACS2broad_blacklistRemoved_""$ID"
bedtools intersect -v -a $sample -b $blacklist > $WORKDIR/blacklistRemoved/$name.broadPeak
#
ID="1Apr22"
SAMPLE2="JUL8"
blacklist=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/blacklist/hg38-blacklist.bed
sample2=$WORKDIR/$SAMPLE2"_MACS2broad_"$ID"_peaks.broadPeak"
name2="$SAMPLE2""_MACS2broad_blacklistRemoved_""$ID"
bedtools intersect -v -a $sample2 -b $blacklist > $WORKDIR/blacklistRemoved/$name2.broadPeak
#
ID="1Apr22"
SAMPLE3="JUL5"
blacklist=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/blacklist/hg38-blacklist.bed
sample3=$WORKDIR/$SAMPLE3"_MACS2broad_"$ID"_peaks.broadPeak"
name3="$SAMPLE3""_MACS2broad_blacklistRemoved_""$ID"
bedtools intersect -v -a $sample3 -b $blacklist > $WORKDIR/blacklistRemoved/$name3.broadPeak

