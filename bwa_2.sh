#bwa_2.sh
#load apps first (below lines). Even though they are in script, let's do this to be sure
#align and then output a sam file

#!/bin/bash
#SBATCH --account=def-juniacke
#SBATCH --job-name=Bwa_Mem
#SBATCH --ntasks-per-node=16
#SBATCH --time=0-08:00:00
#SBATCH --mem-per-cpu=20G
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

GENOME="/cvmfs/ref.mugqic/genomes/species/Homo_sapiens.hg19/genome/Homo_sapiens.hg19.fa"
INDEX="/cvmfs/ref.mugqic/genomes/species/Homo_sapiens.hg19/genome/bwa_index/Homo_sapiens.hg19.fa"

ID="Westgrid"
SAMPLE="westtest"
THREADS=8
WORKDIR=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/Westgrid/$ID
SAM_FILE=$WORKDIR/$SAMPLE.sam

FASTQ_R1=$WORKDIR/$SAMPLE.R1.fastq.gz
FASTQ_R2=$WORKDIR/$SAMPLE.R2.fastq.gz

bwa mem $INDEX $FASTQ_R1 $FASTQ_R2 -t $THREADS > bwa_mem_alignments.sam