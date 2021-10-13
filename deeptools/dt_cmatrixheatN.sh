#!/bin/bash
#SBATCH --account=def-juniacke
#SBATCH --job-name=dt_cmatrixheatN
#SBATCH --ntasks=15
#SBATCH --time=0-05:00:00
#SBATCH --mem-per-cpu=15G
#SBATCH --output=dt_cmatrixheatN.%J.out
#SBATCH --error=dt_cmatrixheatN.%J.err

module load StdEnv/2020
module load python/3.9.6
module load scipy-stack/2021a

pip install deeptools

#dt_cmatrixheatN.sh

#download bam gene list from UCSC (not shown here)
#move that gzip to computecan:
#scp /Users/lexikellington/seq/UCSCgenes.bed.gz akelling@cedar.computecanada.ca:/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools
#gunzip that file once in computecanada

ID="18Sept21"
WORKDIR=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools
genes=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools/UCSCgenes.bed
bigwig="bamcompare_N_""$ID".bw
name="computematrix_N_""$ID"
heatmap="TSSmatrix_N_""$ID"

computeMatrix reference-point -S $WORKDIR/$bigwig -R $genes -a 5000 -b 5000 -o $name --skipZeros

plotHeatmap -m $name -o $heatmap.png --missingDataColor 1 --kmeans 4

#scp akelling@cedar.computecanada.ca:/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools/TSSmatrix_N_18Sept21.png /Users/lexikellington/seq/deeptools
