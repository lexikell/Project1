#DID NOT WORK 

GENOME=/cvmfs/ref.mugqic/genomes/species/Homo_sapiens.GRCh38/genome/Homo_sapiens.GRCh38.fa
INDEX=/cvmfs/ref.mugqic/genomes/species/Homo_sapiens.GRCh38/genome/bwa_index/Homo_sapiens.GRCh38.fa

ID="18Sept21"
SAMPLE="PAbJUL1"
NAME="$SAMPLE""_""$ID"
THREADS=8
WORKDIR=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY
SAM_FILE="$WORKDIR/$ID/$NAME.sam"
BAM_FILE="$WORKDIR/$ID/$NAME.bam"

FASTQ_R1="$WORKDIR/$SAMPLE*_R1_001.fastq.gz"
FASTQ_R2="$WORKDIR/$SAMPLE*_R2_001.fastq.gz"

bwa mem $INDEX $FASTQ_R1 $FASTQ_R2 -M -t $THREADS > $SAM_FILE