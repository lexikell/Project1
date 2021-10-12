#!/bin/bash
#SBATCH --account=def-juniacke
#SBATCH --job-name=dt_bwsum
#SBATCH --ntasks-per-node=8
#SBATCH --time=0-06:00:00
#SBATCH --mem-per-cpu=15G
#SBATCH --output=dt_bwsum.%J.out
#SBATCH --error=dt_bwsum.%J.err

module load StdEnv/2020
module load python/3.9.6
module load scipy-stack/2021a

pip install deeptools

#dt_multibwsum.sh

ID="18Sept21"
WORKDIR=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21
S1=$WORKDIR/"PAbJUL1""_""$ID".bam
S2=$WORKDIR/"PAbJUL3""_""$ID".bam
S3=$WORKDIR/"PAbJUL5""_""$ID".bam
S4=$WORKDIR/"PAbJUL7""_""$ID".bam
C1=$WORKDIR/"CAbJUL2""_""$ID".bam

blacklist=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/blacklist/hg38-blacklist.bed
output=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools
name="multiBamSummary_""$ID"

#correlate bam files using DeepTools MultiBamSummary and plotCorrelation tools 

multiBamSummary bins --bamfiles $S1 $S2 $S3 $S4 $C1 --labels Normoxia Hypoxia Physioxia8 Physioxia5 IgG --blackListFileName $blacklist -o $output/$name.npz


#and graphs? might have to uninstall the R package again (but we added on top so idk)
plotCorrelation -in $output/$name.npz --corMethod spearman --skipZeros --plotTitle "Spearman Correlation of Read Counts" --whatToPlot heatmap --colorMap RdYlBu --plotNumbers -o $output/heatmap_SpearmanCorr_$name.png --outFileCorMatrix $output/SpearmanCorr_$name.tab
plotCorrelation -in $output/$name.npz --corMethod pearson --skipZeros --removeOutliers --plotTitle "Pearson Correlation of Read Counts" --whatToPlot heatmap --colorMap RdYlBu --plotNumbers -o $output/heatmap_PearsonCorr_$name.png --outFileCorMatrix $output/PearsonCorr_$name.tab
plotCorrelation -in $output/$name.npz --corMethod pearson --skipZeros --removeOutliers --plotTitle "Pearson Correlation of Read Counts" --whatToPlot heatmap --colorMap RdYlBu --plotNumbers -o $output/heatmap_PearsonCorr_nooutliers_$name.png --outFileCorMatrix $output/PearsonCorr_nooutliers_$name.tab

#scp akelling@cedar.computecanada.ca:/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools/heatmap_PearsonCorr_nooutliers_multiBamSummary_18Sept21.png /Users/lexikellington/seq/deeptools