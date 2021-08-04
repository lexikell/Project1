#macs2.sh

#!/bin/bash
#SBATCH --account=def-juniacke
#SBATCH --job-name=macs2
#SBATCH --ntasks-per-node=16
#SBATCH --time=0-02:00:00
#SBATCH --mem-per-cpu=16G
#SBATCH --output=BwaMem.%J.out
#SBATCH --error=BwaMem.%J.err

ID="Westgrid"
WORKDIR=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/Westgrid/Westgrid/bwa_1
SAMPLE="samtest"
SAM_FILE=$WORKDIR/bwa_mem_alignments.sam
BAM_FILE=$WORKDIR/$SAMPLE.bam
MACSID="MACS2Test"

#-t file; -f file type; -g genome type (hs human); --outdir in folder "peaks"; -n name
macs2 callpeak -t $BAM_FILE -f BAM -g hs --outdir peaks -n $MACSID -p 1e-5 -B

#then "wc -l .bed" to count the lines in the bed file which is the number of peaks
#then to visualize, use IGV
    #for the files treat_pileup.bdg, 
    #the original bam file and the NarrowPeaks file?