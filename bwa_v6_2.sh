#!/bin/bash
#SBATCH --account=def-juniacke
#SBATCH --job-name=Bwa_Sam
#SBATCH --ntasks-per-node=8
#SBATCH --time=0-06:00:00
#SBATCH --mem-per-cpu=15G
#SBATCH --output=BwaMem.%J.out
#SBATCH --error=BwaMem.%J.err

module load StdEnv/2020
module load python/3.9.6
module load scipy-stack/2021a

module load nixpkgs/16.09  gcc/5.4.0
module load nixpkgs/16.09  gcc/7.3.0
module load nixpkgs/16.09  intel/2016.4
module load nixpkgs/16.09  intel/2017.1
module load nixpkgs/16.09  intel/2018.3

module load bwa/0.7.17
module load StdEnv/2020 samtools/1.12

#bwa_v6.sh

GENOME=/cvmfs/ref.mugqic/genomes/species/Homo_sapiens.GRCh38/genome/Homo_sapiens.GRCh38.fa
INDEX=/cvmfs/ref.mugqic/genomes/species/Homo_sapiens.GRCh38/genome/bwa_index/Homo_sapiens.GRCh38.fa

ID="23Feb22"
SAMPLE="PAbJUL3"
NAME="$SAMPLE""_""$ID"
THREADS=8
WORKDIR=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY
SAM_FILE=$WORKDIR/$ID/$NAME.sam
BAM_FILE=$WORKDIR/$ID/$NAME.bam

#need to make sample folder/dir (ID name) BEFORE you use script! Otherwise it has nowhere to go and you'll get error codes!

FASTQ_R1=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/PAbJUL3_S3_L001_R1_001.fastq.gz
FASTQ_R2=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/PAbJUL3_S3_L001_R2_001.fastq.gz

#run bwa to align
bwa mem $INDEX $FASTQ_R1 $FASTQ_R2 -M -t $THREADS > $SAM_FILE
#use samtools to turn sam into bam
samtools view -b $SAM_FILE -o $BAM_FILE
samtools sort $BAM_FILE -o $BAM_FILE
samtools index $BAM_FILE

