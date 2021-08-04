#!/bin/bash
#SBATCH --account=def-juniacke
#SBATCH --job-name=BAM
#SBATCH --ntasks-per-node=16
#SBATCH --time=0-02:00:00
#SBATCH --mem-per-cpu=16G
#SBATCH --output=BwaMem.%J.out
#SBATCH --error=BwaMem.%J.err

module load StdEnv/2020 samtools/1.12

#samtools.sh
#this will convert your SAM aligned files to BAM format using samtools

ID="Westgrid"
WORKDIR=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/Westgrid/Westgrid
SAMPLE="PAb1_test"
SAM_FILE=$WORKDIR/bwa_mem_alignments.sam
BAM_FILE=$WORKDIR/$SAMPLE.bam

samtools view -b $SAM_FILE -o $BAM_FILE
samtools sort $BAM_FILE -o $BAM_FILE
samtools index $BAM_FILE

#mv files into folder (remove # when ready)
#mkdir $WORKDIR/$SAMPLE
#mv *.out *.err *.bam.bai *.bam $WORKDIR/$SAMPLE

#after script runs, perform "samtools flagstat samtest.bam" for your final BAM file and it will show you stats on your run