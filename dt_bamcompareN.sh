#!/bin/bash
#SBATCH --account=def-juniacke
#SBATCH --job-name=dt_bamcompare
#SBATCH --ntasks-per-node=8
#SBATCH --time=0-08:00:00
#SBATCH --mem-per-cpu=15G
#SBATCH --output=dt_bamcompare.%J.out
#SBATCH --error=dt_bamcompare.%J.err

module load StdEnv/2020
module load python/3.9.6
module load scipy-stack/2021a

pip install git+https://github.com/dpryan79/py2bit
pip install pyBigWig
pip install pysam

pip install deeptools

ID="18Sept21"
WORKDIR=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21
#N and N IgG
S1=$WORKDIR/"PAbJUL1""_""$ID".bam
C1=$WORKDIR/"CAbJUL2""_""$ID".bam
#H and H IgG
S2=$WORKDIR/"PAbJUL3""_""$ID".bam
C2=$WORKDIR/"CAbJUL4""_""$ID".bam
#8% and 8% IgG
S3=$WORKDIR/"PAbJUL5""_""$ID".bam
C3=$WORKDIR/"CAbJUL6""_""$ID".bam
#5% and 5% IgG
S4=$WORKDIR/"PAbJUL7""_""$ID".bam
C4=$WORKDIR/"CAbJUL8""_""$ID".bam

blacklist=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/blacklist/hg38-blacklist.bed
output=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools
name="bamcompare_N_""$ID"

bamCompare -b1 $S1 -b2 $C1 --scaleFactorsMethod SES -bl $blacklist -o $name.bw -of bigwig
