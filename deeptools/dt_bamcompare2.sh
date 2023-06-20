#!/bin/bash
#SBATCH --account=def-juniacke
#SBATCH --job-name=dt_bamcompare8
#SBATCH --ntasks-per-node=15
#SBATCH --time=0-08:00:00
#SBATCH --mem-per-cpu=5G
#SBATCH --output=dt_bamcompare.%J.out
#SBATCH --error=dt_bamcompare.%J.err

module load StdEnv/2020
module load python/3.9.6
module load scipy-stack/2021a

pip install git+https://github.com/dpryan79/py2bit
pip install pyBigWig
pip install pysam

pip install deeptools

WORKDIR=/home/akelling/projects/def-juniacke/akelling/project_202107/20_aligned
ID="1Apr22"

#N and N IgG
S1=$WORKDIR/"JULN""_""$ID".bam
C1=$WORKDIR/"JULNIgG""_""$ID".bam
#H and H IgG
S2=$WORKDIR/"JULH""_""$ID".bam
C2=$WORKDIR/"JULHIgG""_""$ID".bam
#8% and 8% IgG
S3=$WORKDIR/"JUL8""_""$ID".bam
C3=$WORKDIR/"JUL8IgG""_""$ID".bam
#5% and 5% IgG
S4=$WORKDIR/"JUL5""_""$ID".bam
C4=$WORKDIR/"JUL5IgG""_""$ID".bam

blacklist=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/blacklist/hg38-blacklist.bed
output=/home/akelling/projects/def-juniacke/akelling/project_202107/20_aligned/deeptools

#bw IS BINARY
#I can't use RPKM because that normalizes to transcript length for RNA-seq and we don't want to normalize to transcripts 

name1="bamcompare_N_""$ID"
bamCompare -b1 $S1 -b2 $C1 --scaleFactorsMethod SES -bl $blacklist -o $name1.bw -of bigwig

name2="bamcompare_H_""$ID"
bamCompare -b1 $S2 -b2 $C2 --scaleFactorsMethod SES -bl $blacklist -o $name2.bw -of bigwig

name3="bamcompare_8_""$ID"
bamCompare -b1 $S3 -b2 $C3 --scaleFactorsMethod SES -bl $blacklist -o $name3.bw -of bigwig

name4="bamcompare_5_""$ID"
bamCompare -b1 $S4 -b2 $C4 --scaleFactorsMethod SES -bl $blacklist -o $name4.bw -of bigwig
