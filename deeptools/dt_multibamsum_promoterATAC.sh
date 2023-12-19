#!/bin/bash
#SBATCH --account=def-juniacke
#SBATCH --job-name=dt_bamsumother
#SBATCH --ntasks-per-node=8
#SBATCH --time=0-06:00:00
#SBATCH --mem-per-cpu=5G
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

#dt_multibamsumpromoterATAC.sh

ID="18Sept21"
WORKDIR=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21
INDEX=/cvmfs/ref.mugqic/genomes/species/Homo_sapiens.GRCh38/genome/bwa_index/Homo_sapiens.GRCh38.fa.fai

#samples: only +5000 - -1000 (promoter region only)
S1=$WORKDIR/"PAbJUL1""_""$ID".bam
NBAM=/home/akelling/projects/def-juniacke/akelling/project_202107/30_bioconductor/rep1/chippeakanno/annoIDsNdf_up5000down1000.bam
5BAM=/home/akelling/projects/def-juniacke/akelling/project_202107/30_bioconductor/rep1/chippeakanno/annoIDs5df_up5000down1000.bam
HBAM=/home/akelling/projects/def-juniacke/akelling/project_202107/30_bioconductor/rep1/chippeakanno/annoIDsHdf_up5000down1000.bam

#Vishnu 2021 ATACseq BAM
ATACBAM=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/OutsideData/Vishnu2021/Vishnu2021_NicEseq.bam

blacklist=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/blacklist/hg38-blacklist.bed
output=/home/akelling/projects/def-juniacke/akelling/project_202107/40_deeptools
name="multibamSum_promoterATAC"

multiBamSummary bins --bamfiles $NBAM $5BAM $HBAM $ATACBAM $S1 --labels NormoxicPromoters PhysioxicPromoters HypoxicPromoters ATACseq Normoxia --blackListFileName $blacklist -o $output/$name.npz

#and graphs? 
plotCorrelation -in $output/$name.npz --corMethod spearman --skipZeros --plotTitle "Spearman Correlation of Read Counts" --whatToPlot heatmap --colorMap coolwarm --plotNumbers -o $output/heatmap_$name.png --outFileCorMatrix $output/SpearmanCorr_$name.tab

#more figures 22Feb23

#plotCorrelation -in $output/$name.npz --corMethod spearman --skipZeros --plotTitle "Spearman Correlation of Average Scores Per Transcript" \
#--whatToPlot scatterplot -o $output/scatterplot_$name.png

#plotPCA -in $output/$name.npz -o $output/PCAreadCounts_$name.png -T "PCA of read counts"

#onto local to visualize
#scp akelling@cedar.computecanada.ca:/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools/other/scatterplot_multibamSum_OGG1.png /Users/lexikellington/seq/deeptools
