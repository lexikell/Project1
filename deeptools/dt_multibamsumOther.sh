#!/bin/bash
#SBATCH --account=def-juniacke
#SBATCH --job-name=dt_bamsumother
#SBATCH --ntasks-per-node=8
#SBATCH --time=0-04:00:00
#SBATCH --mem-per-cpu=3G
#SBATCH --output=dt_bamsum.%J.out
#SBATCH --error=dt_bamsum.%J.err

module load StdEnv/2020
module load gcc/9.3.0
module load python/3.9
module load scipy-stack/2021a
module load imkl/2020.1.217

pip install plotly
pip install deeptools

#dt_multibamsumOther.sh

ID="18Sept21"
WORKDIR=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21
INDEX=/cvmfs/ref.mugqic/genomes/species/Homo_sapiens.GRCh38/genome/bwa_index/Homo_sapiens.GRCh38.fa.fai
#Samples
S1=$WORKDIR/"PAbJUL1""_""$ID".bam
S2=$WORKDIR/"PAbJUL3""_""$ID".bam
S3=$WORKDIR/"PAbJUL5""_""$ID".bam
S4=$WORKDIR/"PAbJUL7""_""$ID".bam
C1=$WORKDIR/"CAbJUL2""_""$ID".bam

#Hao2018: FLAG-OGG1 ChIP data
S7=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/OutsideData/Hao2018/Hao2018_FLAGOGG1.bam

blacklist=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/blacklist/hg38-blacklist.bed
output=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools/other
name="multibamSum_OGG1"

multiBamSummary bins --bamfiles $C1 $S1 $S2 $S3 $S4 $S7 --labels IgG Normoxia Hypoxia Physioxia8 Physioxia5 OGG1 --blackListFileName $blacklist -o $output/$name.npz

#and graphs? 
plotCorrelation -in $output/$name.npz --corMethod spearman --skipZeros --plotTitle "Spearman Correlation of Read Counts" --whatToPlot heatmap --colorMap coolwarm --plotNumbers -o $output/heatmap_$name.png --outFileCorMatrix $output/SpearmanCorr_$name.tab

#onto local to visualize
#scp akelling@cedar.computecanada.ca:/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools/other/heatmap_multibamSum_OGG1.png /Users/lexikellington/seq/deeptools
