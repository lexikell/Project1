#macs2_broad.sh

#!/bin/bash
#SBATCH --account=def-juniacke
#SBATCH --job-name=macs2
#SBATCH --ntasks-per-node=16
#SBATCH --time=0-02:00:00
#SBATCH --mem-per-cpu=5G
#SBATCH --output=BwaMem.%J.out
#SBATCH --error=BwaMem.%J.err

module load StdEnv/2020
module load python/3.9.6
module load scipy-stack/2021a
pip install macs2 --user
MACS2=$HOME/.local/bin/macs2

ID="Westgrid"
date="11Sep21"
WORKDIR=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/Westgrid/Westgrid/PAb1_test
SAMPLE="PAb1_test"
CNTL="CAb2_test"
SAM_FILE=$WORKDIR/bwa_mem_alignments.sam
BAM_FILE=$WORKDIR/$SAMPLE.bam
BAM_FILE_CNTL=$WORKDIR/$CNTL.bam
MACSID="MACS2PAb1_$date"

#-t file; -f file type; -g genome type (hs human); --outdir in folder "peaks"; -n name
#this has a looser cuttoff for nearby peaks and averages the score of the larger region
#this also adds the control bam file

macs2 callpeak -t $BAM_FILE -c $BAM_FILE_CNTL -f BAM --broad -g hs --outdir peaks -n $MACSID --broad-cutoff 0.1 -B

#then "wc -l .bed" to count the lines in the bed file which is the number of peaks
#then to visualize, use IGV
    #bam file is aligned - all read will show & peaks file is just peaks 
    #narrowPeaks (colour coded for stronger peaks)
    #summits.bed (similar to narrow, shows all statsig peaks)
    #and the bam file output from samtools (shows the actual pileup of sequences)