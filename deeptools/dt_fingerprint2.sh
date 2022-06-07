#!/bin/bash
#SBATCH --account=def-juniacke
#SBATCH --job-name=dt_finger
#SBATCH --ntasks-per-node=8
#SBATCH --time=0-6:00:00
#SBATCH --mem-per-cpu=1G
#SBATCH --output=dt_finger.%J.out
#SBATCH --error=dt_finger.%J.err

module load StdEnv/2020
module load python/3.9.6
module load scipy-stack/2021a
module load imkl/2020.1.217
module unload r-bundle-bioconductor/3.12

pip install plotly

pip install deeptools

ID="1Apr22"
WORKDIR=/home/akelling/projects/def-juniacke/akelling/project_202107/20_aligned
S1=$WORKDIR/"JULN""_""$ID".bam
S2=$WORKDIR/"JULH""_""$ID".bam
S3=$WORKDIR/"JUL8""_""$ID".bam
S4=$WORKDIR/"JUL5""_""$ID".bam
C1=$WORKDIR/"JULNIgG""_""$ID".bam
C2=$WORKDIR/"JULHIgG""_""$ID".bam

blacklist=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/blacklist/hg38-blacklist.bed
output=/home/akelling/projects/def-juniacke/akelling/project_202107/20_aligned/deeptools
name="fingerprint_2IgG_""$ID"

plotFingerprint -b $S1 $S2 $S3 $S4 $C1 $C2 --labels Normoxia Hypoxia Physioxia8 Physioxia5 IgG1 IgG2 --minMappingQuality 30 --skipZeros \
-bl $blacklist -T "Fingerprints of OG-seq samples rep2" --plotFile $name.png --outRawCounts $name.tab

#scp akelling@cedar.computecanada.ca:/home/akelling/projects/def-juniacke/akelling/project_202107/20_aligned/deeptools/fingerprint_2IgG_1Apr22.png /Users/lexikellington/seq/deeptools
