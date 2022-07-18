#!/bin/bash
#SBATCH --account=def-juniacke
#SBATCH --job-name=macs2_broad
#SBATCH --ntasks-per-node=6
#SBATCH --time=0-00:55:00
#SBATCH --mem-per-cpu=3G
#SBATCH --output=BwaMem.%J.out
#SBATCH --error=BwaMem.%J.err

module load StdEnv/2020
module load python/3.9.6
module load scipy-stack/2021a
pip install macs2 --user

ID="1Apr22"
WORKDIR=/home/akelling/projects/def-juniacke/akelling/project_202107/20_aligned
OUTDIR=/home/akelling/projects/def-juniacke/akelling/project_202107/20_aligned/macs2
SAMPLE="JULN"
CNTL="JULNIgG"
SNAME="$SAMPLE""_""$ID"
CNAME="$CNTL""_""$ID"

BAM_FILE=$WORKDIR/$SNAME.bam
BAM_FILE_CNTL=$WORKDIR/$CNAME.bam
MACSID="$SAMPLE""_MACS2broad_""15Jul22"

#-t file; -f file type; -g genome type (hs human); --outdir in folder "peaks"; -n name
#this has a looser cuttoff for nearby peaks and averages the score of the larger region
#this also adds the control bam file

macs2 callpeak -t $BAM_FILE -c $BAM_FILE_CNTL -f BAM --broad -g hs --outdir macs2 -n $MACSID --bdg

#then "wc -l .bed" to count the lines in the bed file which is the number of peaks
#the output files are in bedgraph format. You want to later convert these to bigwig, which is the binary file which is smaller