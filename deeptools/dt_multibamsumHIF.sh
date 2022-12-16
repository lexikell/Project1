#!/bin/bash
#SBATCH --account=def-juniacke
#SBATCH --job-name=dt_bamsum
#SBATCH --ntasks-per-node=8
#SBATCH --time=0-02:00:00
#SBATCH --mem-per-cpu=2G
#SBATCH --output=dt_bamsum.%J.out
#SBATCH --error=dt_bamsum.%J.err

module load StdEnv/2020
module load gcc/9.3.0
module load python/3.9
module load scipy-stack/2021a
module load imkl/2020.1.217
module load nixpkgs/16.09  intel/2018.3
pip install plotly
pip install deeptools
module load bedtools/2.30.0

#dt_multibamsumHIF.sh

ID="18Sept21"
WORKDIR=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21
INDEX=/cvmfs/ref.mugqic/genomes/species/Homo_sapiens.GRCh38/genome/bwa_index/Homo_sapiens.GRCh38.fa.fai
#Samples
S1=$WORKDIR/"PAbJUL1""_""$ID".bam
S2=$WORKDIR/"PAbJUL3""_""$ID".bam
S3=$WORKDIR/"PAbJUL5""_""$ID".bam
S4=$WORKDIR/"PAbJUL7""_""$ID".bam
C1=$WORKDIR/"CAbJUL2""_""$ID".bam

#Other samples
#Salama2015: ChIP-Seq of HIF-1a in 786-O with HIF-1a re-expression
S5=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/OutsideData/Salama2015/GSM1642764_HIF1a_1a.bed
#Salama2015: ChIP-Seq of HIF-2a in 786-O with HIF-2a over expression (kidney cancer cell line)
S6=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/OutsideData/Salama2015/GSM1642769_HIF2a_2a.bed
#Hao2018: FLAG-OGG1 ChIP data
#S7=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/OutsideData/Hao2018/Hao2018_FLAGOGG1.bam

S5BAM=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/OutsideData/Salama2015/GSM1642764_HIF1a_1a.bam
S6BAM=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/OutsideData/Salama2015/GSM1642769_HIF2a_2a.bam

#First, use bedtools to turn the .bed files into .bam files
#this was done as an interactive job
#This also can't be run on bed files with only 3 columns so first I added a "dummy line":
awk '{print $0, 255}' $S5 > GSM1642764_HIF1a_1a_bed4.bed
awk '{print $0, 255}' $S6 > GSM1642769_HIF2a_2a.bed4.bed

sed 's/ \+//g' GSM1642764_HIF1a_1a_bed4.bed > GSM1642764_HIF1a_1a_bed4tab.bed

bedToBam -i /home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/OutsideData/Salama2015/GSM1642764_HIF1a_1a_bed4tab.bed -g $INDEX > $S5BAM
bedToBam -i /home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/OutsideData/Salama2015/GSM1642769_HIF2a_2a.bed4.bed -g $INDEX > $S6BAM

tr [:space:] "\t" < GSM1642764_HIF1a_1a_bed4.bed > GSM1642764_HIF1a_1a_bed4tab.bed

blacklist=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/blacklist/hg38-blacklist.bed
output=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools/other
name="multibamSum_HIF"

multiBamSummary bins --bamfiles $C1 $S1 $S2 $S3 $S4 $SBAM $S6BAM --labels IgG Normoxia Hypoxia Physioxia8 Physioxia5 HIF1a HIF2a --blackListFileName $blacklist -o $output/$name.npz

#and graphs? 
plotCorrelation -in $output/$name.npz --corMethod spearman --skipZeros --plotTitle "Spearman Correlation of Read Counts" --whatToPlot heatmap --colorMap coolwarm --plotNumbers -o $output/heatmap_$name.png --outFileCorMatrix $output/SpearmanCorr_$name.tab

#onto local to visualize
#scp akelling@cedar.computecanada.ca:/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools/heatmap_multibwSummary_all_genes18Sept21.png /Users/lexikellington/seq/deeptools
