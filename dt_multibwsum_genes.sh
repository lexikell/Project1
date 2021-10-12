#!/bin/bash
#SBATCH --account=def-juniacke
#SBATCH --job-name=dt_bwsumgenes
#SBATCH --ntasks-per-node=8
#SBATCH --time=0-01:00:00
#SBATCH --mem-per-cpu=1G
#SBATCH --output=dt_bwsumgenes.%J.out
#SBATCH --error=dt_bwsumgenes.%J.err

module load StdEnv/2020
module load gcc/9.3.0
module load python/3.9
module load scipy-stack/2021a
module load imkl/2020.1.217
module unload r-bundle-bioconductor/3.12

pip install plotly

pip install deeptools

#dt_multibwsumgenes.sh

ID="18Sept21"
WORKDIR=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools

#N and N IgG
S1=$WORKDIR/"bamcompare_N_""$ID".bw
NC=$WORKDIR/"bamcoverage_NC_""$ID".bw
#H and H IgG
S2=$WORKDIR/"bamcompare_H_""$ID".bw
HC=$WORKDIR/"bamcoverage_HC_""$ID".bw
#8% and 8% IgG
S3=$WORKDIR/"bamcompare_8_""$ID".bw
C8=$WORKDIR/"bamcoverage_8C_""$ID".bw
#5% and 5% IgG
S4=$WORKDIR/"bamcompare_5_""$ID".bw
C5=$WORKDIR/"bamcoverage_8C_""$ID".bw

blacklist=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/blacklist/hg38-blacklist.bed
output=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools
genes=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools/UCSCgenes.bed
name="multibwSummary_all_genes""$ID"

#correlate bigwig files using DeepTools MultiBigwigSummary and plotCorrelation tools 

multiBigwigSummary BED-file -b $S1 $S2 $S3 $S4 $NC $HC $C8 $C5 --labels Normoxia Hypoxia Physioxia8 Physioxia5 IgGN IgGH IgG8 IgG5 --BED $genes --blackListFileName $blacklist -o $output/$name.npz

#and graphs? might have to uninstall the R package again (but we added on top so idk)
plotCorrelation -in $output/$name.npz --corMethod spearman --skipZeros --plotTitle "Spearman Correlation of Read Counts" --whatToPlot heatmap --colorMap coolwarm --plotNumbers -o $output/heatmap_$name.png --outFileCorMatrix $output/SpearmanCorr_$name.tab

#scp akelling@cedar.computecanada.ca:/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools/heatmap_multibwSummary_all_genes18Sept21.png /Users/lexikellington/seq/deeptools
