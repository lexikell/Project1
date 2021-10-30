#!/bin/bash
#SBATCH --account=def-juniacke
#SBATCH --job-name=bc_ChIPpeakanno
#SBATCH --time=0-00:20:00   # time (DD-HH:MM)
#SBATCH --mem-per-cpu=1G
#SBATCH --output=bc_ChIPpeakanno.%J.out
#SBATCH --error=bc_ChIPpeakanno.%J.err


module load StdEnv/2020 gcc/9.3.0
module load r/4.1.0
module load r-bundle-bioconductor/3.12

filepath=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/macs2/blacklistRemoved
file="PAbJUL1_MACS2broad_blacklistRemoved_18Sept21.broadPeak"
WORKDIR=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/ChIPpeakanno

ChIPpeakAnno toGRanges $filepath/$file --format MACS
#^ChIPpeakAnno is not a command