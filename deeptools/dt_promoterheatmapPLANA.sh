#!/bin/bash
#SBATCH --account=def-juniacke
#SBATCH --job-name=dt_promoterheatmap
#SBATCH --ntasks=15
#SBATCH --time=0-03:00:00
#SBATCH --mem-per-cpu=1G
#SBATCH --output=dt_promoterheatmap.%J.out
#SBATCH --error=dt_promoterheatmap.%J.err

module load StdEnv/2020
module load python/3.9.6
module load scipy-stack/2021a
pip install deeptools

ID="18Sept21"
WORKDIR=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21
#N and N IgG
S1=$WORKDIR/"PAbJUL1""_""$ID".bam
C1=$WORKDIR/"CAbJUL2""_""$ID".bam
#H and H IgG
S2=$WORKDIR/"PAbJUL3""_""$ID".bam
C2=$WORKDIR/"CAbJUL4""_""$ID".bam
#8% and 8% IgG
S3=$WORKDIR/"PAbJUL5""_""$ID".bam
C3=$WORKDIR/"CAbJUL6""_""$ID".bam
#5% and 5% IgG
S4=$WORKDIR/"PAbJUL7""_""$ID".bam
C4=$WORKDIR/"CAbJUL8""_""$ID".bam

blacklist=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/blacklist/hg38-blacklist.bed
output=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools
name="promoterheatmapPLANA"
genes=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools/UCSCgenes.bed

NBAM=/home/akelling/projects/def-juniacke/akelling/project_202107/30_bioconductor/rep1/chippeakanno/annoIDsNdf_up5000down1000.bam
5BAM=/home/akelling/projects/def-juniacke/akelling/project_202107/30_bioconductor/rep1/chippeakanno/annoIDs5df_up5000down1000.bam
HBAM=/home/akelling/projects/def-juniacke/akelling/project_202107/30_bioconductor/rep1/chippeakanno/annoIDsHdf_up5000down1000.bam

#PLAN A
#let's trim our bw to just our promoter regions so that we can use kmeans and normal genes to compare 

#turn the BAMs into bigwigs comparing to the control using bamcompare 
bamCompare -b1 $S4 -b2 $C4 --scaleFactorsMethod readCount -bl $blacklist -o $name.bw -of bigwig

#make the compute matrix 


#visualize using plotheatmap
plotHeatmap -m matrix_two_groups.gz -out $name.png \
     --zMin -3 --zMax 3 --kmeans 4

