#!/bin/bash
#SBATCH --account=def-juniacke
#SBATCH --job-name=dt_bwsum
#SBATCH --ntasks-per-node=8
#SBATCH --time=0-01:00:00
#SBATCH --mem-per-cpu=1G
#SBATCH --output=dt_bwsum.%J.out
#SBATCH --error=dt_bwsum.%J.err

module load StdEnv/2020
module load gcc/9.3.0
module load python/3.9
module load scipy-stack/2021a
module load imkl/2020.1.217
module unload r-bundle-bioconductor/3.12

pip install plotly

pip install deeptools

#dt_multibwsumS5.sh

ID="1Apr22"
WORKDIR=/home/akelling/projects/def-juniacke/akelling/project_202107/20_aligned/deeptools

#REP1 5% and 5% IgG
S5r1=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools/bamcompare_5_18Sept21.bw
C5r1=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools/bamcoverage_5C_18Sept21.bw

#REP2 5% and 5% IgG
S5r2=$WORKDIR/"bamcompare_5_""$ID".bw
C5r2=$WORKDIR/"bamcoverage_5C_""$ID".bw

blacklist=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/blacklist/hg38-blacklist.bed
output=/home/akelling/projects/def-juniacke/akelling/project_202107/20_aligned/deeptools
name="multibwSummary_5s_""$ID"

#correlate bigwig files using DeepTools MultiBigwigSummary and plotCorrelation tools 

multiBigwigSummary bins -b $S5r1 $S5r2 $C5r1 $C5r2 --labels Physioxia5r1 Physioxia5r2 IgG5r1 IgG5r2 --blackListFileName $blacklist -o $output/$name.npz

#and graphs? might have to uninstall the R package again (but we added on top so idk)
plotCorrelation -in $output/$name.npz --corMethod spearman --skipZeros --plotTitle "Spearman Correlation of Read Counts" \
--whatToPlot heatmap --colorMap RdYlGn --plotNumbers -o $output/heatmap_$name.png --outFileCorMatrix $output/SpearmanCorr_$name.tab

#scatterplot too
plotCorrelation -in $output/$name.npz --corMethod spearman --skipZeros --plotTitle "Pearson Correlation of Average Scores Per Transcript" \
--whatToPlot scatterplot -o $output/scatterplot_$name.png

#scp akelling@cedar.computecanada.ca:/home/akelling/projects/def-juniacke/akelling/project_202107/20_aligned/deeptools/scatterplot_multibwSummary_5s_1Apr22.png /Users/lexikellington/seq/deeptools
