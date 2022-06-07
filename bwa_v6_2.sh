#!/bin/bash
#SBATCH --account=def-juniacke
#SBATCH --job-name=Bwa_Sam
#SBATCH --ntasks-per-node=8
#SBATCH --time=0-05:00:00
#SBATCH --mem-per-cpu=9G
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

#bwa_v6_2.sh

#Rep2 = 111021AKellington
#   /home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington
#   - 8 samples; each in 4 lanes; each lane has 2 reads
#   - seperate QC
#   - each sample: cat the 4 R1 gzips together (and same for R2s) -> file merging in script "pre-bwa_v6_2.sh"

GENOME=/cvmfs/ref.mugqic/genomes/species/Homo_sapiens.GRCh38/genome/Homo_sapiens.GRCh38.fa
INDEX=/cvmfs/ref.mugqic/genomes/species/Homo_sapiens.GRCh38/genome/bwa_index/Homo_sapiens.GRCh38.fa

ID="1Apr22"
SAMPLE="JUL5IgG"
NAME="$SAMPLE""_""$ID"
THREADS=8
SAMPLEDIR=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington
WORKDIR=/home/akelling/projects/def-juniacke/akelling/project_202107/20_aligned
SAM_FILE=$WORKDIR/$NAME.sam
BAM_FILE=$WORKDIR/$NAME.bam
#need to make sample folder/dir (ID name) BEFORE you use script! Otherwise it has nowhere to go and you'll get error codes!
FASTQ_R1=$SAMPLEDIR/JUL5IgG_R1merge.fastq.gz
FASTQ_R2=$SAMPLEDIR/JUL5IgG_R2merge.fastq.gz

#run bwa to align
bwa mem $INDEX $FASTQ_R1 $FASTQ_R2 -M -t $THREADS > $SAM_FILE
#use samtools to turn sam into bam
samtools view -b $SAM_FILE -o $BAM_FILE
samtools sort $BAM_FILE -o $BAM_FILE
samtools index $BAM_FILE
