#!/bin/bash
#SBATCH --account=def-juniacke
#SBATCH --job-name=bedtools
#SBATCH --ntasks=15
#SBATCH --time=0-14:00:00
#SBATCH --mem-per-cpu=40G
#SBATCH --output=bedtools.%J.out
#SBATCH --error=bedtools.%J.err

module load StdEnv/2020 
module load nixpkgs/16.09  gcc/7.3.0
module load nixpkgs/16.09  intel/2018.3
module load bedtools/2.29.2

#bedtools.sh

ID="18Sept21"
WORKDIR=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/macs2/blacklistRemoved
output=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/bedtools
genes=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools/UCSCgenes.bed
enhancers=

Nbam=$WORKDIR/"PAbJUL1""_MACS2broad_blacklistRemoved_""$ID".bed
NSorted=$output/"N_MACS2broad_""$ID".sort.bed
Hbam=$WORKDIR/"PAbJUL3""_MACS2broad_blacklistRemoved_""$ID".bed
HSorted=$output/"H_MACS2broad_""$ID".sort.bed
bam8=$WORKDIR/"PAbJUL5""_MACS2broad_blacklistRemoved_""$ID".bed
Sorted8=$output/"8_MACS2broad_""$ID".sort.bed
bam5=$WORKDIR/"PAbJUL7""_MACS2broad_blacklistRemoved_""$ID".bed
Sorted5=$output/"5_MACS2broad_""$ID".sort.bed

name=

sort -k1,1 -k2,2n $Nbam > $NSorted
sort -k1,1 -k2,2n $Hbam > $HSorted
sort -k1,1 -k2,2n $bam8 > $Sorted8
sort -k1,1 -k2,2n $bam5 > $Sorted5

