#bwa.sh
#downloaded nec programs first

#!/bin/bash
#SBATCH --account=def-akelling
#SBATCH --mem-per-cpu=1G
#SBATCH --time=00:02:00
#SBATCH --job-name=bwa.test
#SBATCH --output=%x-%j.out

INDEX="/cvmfs/ref.mugqic/genomes/species/Homo_sapiens.hg19/genome/bwa_index/Homo_sapiens.hg19.fa"

ID="Westgrid"
SAMPLE="westtest"
THREADS=16
WORKDIR=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/Westgrid/$ID
SAM_FILE=$WORKDIR/$SAMPLE.sam

FASTQ_R1=$WORKDIR/$SAMPLE.R1.fastq.gz
FASTQ_R2=$WORKDIR/$SAMPLE.R2.fastq.gz

#1st command: map the reads to the genome using BWA
#This if/fi loop only does what's in the block if the files do not already exist - that way if you have to run this again, it will just skip this par>
if [ ! -f $SAM_FILE ]; then
    bwa mem -t $THREADS -M \
    -R "@RG\tID:$ID\tSM:$SAMPLE\tPL:$PLATFORM" \
    $INDEX $FASTQ_R1 $FASTQ_R2 > $SAM_FILE
fi