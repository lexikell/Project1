#!/bin/bash
#SBATCH --account=def-juniacke
#SBATCH --job-name=dt_cmatrixheat
#SBATCH --ntasks=15
#SBATCH --time=0-03:00:00
#SBATCH --mem-per-cpu=3G
#SBATCH --output=dt_cmatrixheat.%J.out
#SBATCH --error=dt_cmatrixheat.%J.err

module load StdEnv/2020
module load python/3.9.6
module load scipy-stack/2021a

pip install deeptools

#dt_cmatrixheat.sh

#download bam gene list from UCSC (not shown here)
#move that gzip to computecan:
#scp /Users/lexikellington/seq/UCSCgenes.bed.gz akelling@cedar.computecanada.ca:/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools
#gunzip that file once in computecanada

ID="18Sept21"
WORKDIR=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools
genes=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools/UCSCgenes.bed
bigwig="bamcompare_H_""$ID".bw
name="computematrix_H_""$ID"
heatmap="TSSmatrix_H_""$ID"

computeMatrix reference-point -S $WORKDIR/$bigwig -R $genes -a 5000 -b 5000 -o $name

plotHeatmap -m $name -o $heatmap.png --missingDataColor 1
