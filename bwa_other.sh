#!/bin/bash
#SBATCH --account=def-juniacke
#SBATCH --job-name=Bwa
#SBATCH --ntasks-per-node=8
#SBATCH --time=0-07:00:00
#SBATCH --mem-per-cpu=11G
#SBATCH --output=Bwa.%J.out
#SBATCH --error=Bwa.%J.err

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

#bwa_other.sh

INDEX=/cvmfs/ref.mugqic/genomes/species/Homo_sapiens.GRCh38/genome/bwa_index/Homo_sapiens.GRCh38.fa

NAME="Vishnu2021_NicEseq"
THREADS=8
WORKDIR=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/OutsideData/Vishnu2021
SAM_FILE=$WORKDIR/$NAME.sam
BAM_FILE=$WORKDIR/$NAME.bam

FASTQ=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/OutsideData/Vishnu2021/SRR14667268/SRR14667268.fastq
#WARNING: this will error if there are temporary files already in the folder 
    #AKA if it times out and you have to re-run! So delete before running again!
#run bwa to align
bwa mem $INDEX $FASTQ -M -t $THREADS > $SAM_FILE
#use samtools to turn sam into bam
samtools view -b $SAM_FILE -o $BAM_FILE
samtools sort $BAM_FILE -o $BAM_FILE
samtools index $BAM_FILE
