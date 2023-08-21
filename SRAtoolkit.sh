#!/bin/bash
#SBATCH --account=def-juniacke
#SBATCH --job-name=SRA
#SBATCH --ntasks-per-node=1
#SBATCH --nodes=1
#SBATCH --time=0-00:20:00
#SBATCH --mem-per-cpu=100M
#SBATCH --output=SRA.%J.out
#SBATCH --error=SRA.%J.err

module load StdEnv/2020  gcc/9.3.0
module load sra-toolkit/3.0.0

vdb-config --interactive
#^ I didn't do the interactive part bc it looked weird when I did that

#SRA.sh

#The SRA Toolkit should let you remotely download data from the SRA db 
#SRA Toolkit is already a default instalation in CC

#navigate to the folder you want to save the files in before you run this 
#>/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/OutsideData/Hao2018

#here: SRA file for HEK293 cells overexpressing FLAG-OGG1 and ChIP-seq w/ anti-FLAG (Hao 2018)
#https://www.ncbi.nlm.nih.gov/sra?LinkName=biosample_sra&from_uid=5933067

#download file:
prefetch SRR4436791

#convert the SRA files into FASTQ format
fastq-dump SRR4436791


