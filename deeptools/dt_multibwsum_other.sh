#!/bin/bash
#SBATCH --account=def-juniacke
#SBATCH --job-name=dt_bwsumgenes
#SBATCH --ntasks-per-node=8
#SBATCH --time=0-01:00:00
#SBATCH --mem-per-cpu=2G
#SBATCH --output=dt_bwsum.%J.out
#SBATCH --error=dt_bwsum.%J.err

module load StdEnv/2020
module load gcc/9.3.0
module load python/3.9
module load scipy-stack/2021a
module load imkl/2020.1.217

pip install plotly

pip install deeptools

#dt_multibwsum_other.sh

ID="18Sept21"
WORKDIR=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools

#N and N IgG
S1=$WORKDIR/bamcompare_N_18Sept21.bw
NC=$WORKDIR/"bamcoverage_NC_""$ID".bw
#H and H IgG
S2=$WORKDIR/bamcompare_H_18Sept21.bw
HC=$WORKDIR/"bamcoverage_HC_""$ID".bw
#8% and 8% IgG
S3=$WORKDIR/bamcompare_8_18Sept21.bw
C8=$WORKDIR/"bamcoverage_8C_""$ID".bw
#5% and 5% IgG
S4=$WORKDIR/bamcompare_5_18Sept21.bw
C5=$WORKDIR/"bamcoverage_8C_""$ID".bw

#scp /Users/lexikellington/Downloads/GSE175651_HEK293_5K.bw akelling@cedar.computecanada.ca:/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/OutsideData/Vishnu2021

ATAC=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/OutsideData/Vishnu2021/GSE175651_HEK293_5K.bw

blacklist=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/blacklist/hg38-blacklist.bed
output=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/OutsideData/Calviello2019/deeptools
genes=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools/UCSCgenes.bed
name="multibwSummary_ATAC"

#correlate bigwig files using DeepTools MultiBigwigSummary and plotCorrelation tools 

#removed the BED-file mode (that is in dt_multibwsumgenes.sh) 
#so that it doesn't descriminate for just gene names - cause this will be for the ATAC-seq data 

multiBigwigSummary BED-file -b $S1 $S2 $S3 $S4 $NC $ATAC --labels Normoxia Hypoxia Physioxia8 Physioxia5 IgG ATAC-seq --BED $genes --blackListFileName $blacklist -o $output/$name.npz

#and graphs? might have to uninstall the R package again (but we added on top so idk)
plotCorrelation -in $output/$name.npz --corMethod spearman --skipZeros --plotTitle "Spearman Correlation of Read Counts" --whatToPlot heatmap --colorMap coolwarm --plotNumbers -o $output/heatmap_$name.png --outFileCorMatrix $output/SpearmanCorr_$name.tab

#scatterplot too
plotCorrelation -in $output/$name.npz --corMethod spearman --skipZeros --plotTitle "Pearson Correlation of Average Scores Per Transcript" \
--whatToPlot scatterplot -o $output/scatterplot_$name.png

#scp akelling@cedar.computecanada.ca:/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/OutsideData/Calviello2019/deeptools/scatterplot_multibwSummary_ATAC.png /Users/lexikellington/seq/deeptools
