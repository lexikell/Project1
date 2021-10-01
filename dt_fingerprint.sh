#!/bin/bash
#SBATCH --account=def-juniacke
#SBATCH --job-name=dt_finger
#SBATCH --ntasks-per-node=8
#SBATCH --time=0-6:00:00
#SBATCH --mem-per-cpu=2G
#SBATCH --output=dt_finger.%J.out
#SBATCH --error=dt_finger.%J.err

module load StdEnv/2020
module load python/3.9.6
module load scipy-stack/2021a
module load imkl/2020.1.217
module unload r-bundle-bioconductor/3.12

pip install plotly

pip install deeptools

ID="18Sept21"
WORKDIR=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21
S1=$WORKDIR/"PAbJUL1""_""$ID".bam
S2=$WORKDIR/"PAbJUL3""_""$ID".bam
S3=$WORKDIR/"PAbJUL5""_""$ID".bam
S4=$WORKDIR/"PAbJUL7""_""$ID".bam
C1=$WORKDIR/"CAbJUL2""_""$ID".bam
C2=$WORKDIR/"CAbJUL4""_""$ID".bam
C3=$WORKDIR/"CAbJUL6""_""$ID".bam
C4=$WORKDIR/"CAbJUL8""_""$ID".bam

blacklist=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/blacklist/hg38-blacklist.bed
output=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools
name="fingerprint_all_""$ID"

plotFingerprint -b $S1 $S2 $S3 $S4 $C1 $C2 $C3 $C4 --labels Normoxia Hypoxia Physioxia8 Physioxia5 IgGN IgGH IgG8 IgG5 --minMappingQuality 30 --skipZeros \
-bl $blacklist -T "Fingerprints of OG-seq samples" --plotFile $name.png --outRawCounts $name.tab

#scp akelling@cedar.computecanada.ca:/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools/fingerprint_all_18Sept21.png /Users/lexikellington/seq/deeptools

#worked!
#do with either the 8 or H IgG and the other samples