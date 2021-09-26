#!/bin/bash
#SBATCH --account=def-juniacke
#SBATCH --job-name=blacklist
#SBATCH --ntasks-per-node=8
#SBATCH --time=0-06:00:00
#SBATCH --mem-per-cpu=15G
#SBATCH --output=BwaMem.%J.out
#SBATCH --error=BwaMem.%J.err

module load StdEnv/2020
module load nixpkgs/16.09  gcc/7.3.0
module load nixpkgs/16.09  intel/2018.3

module load bedtools/2.29.2

blacklist=~/projects/def-sponsor00/SHARE/ChIP-seq/resources/QC_resources/hg38_blacklist.bed LINK YOURS
input=~/peaks/MCF10A_H3K27ac_peaks.narrowPeak PAb FILE
sample="MCF10A_H3K27ac_peaks" NAME IT
bedtools intersect -v -a ${input} -b ${blacklist} > ~/peaks/${sample}.blacklistRemoved.narrowPeak THE ONE YOU WANT
bedtools intersect -u -a ${input} -b ${blacklist} > ~/peaks/${sample}.blacklist.narrowPeak YOU DONT CARE ABOUT THE BLACKLIST AS AN OUTPUT