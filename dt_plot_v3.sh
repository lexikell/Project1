#!/bin/bash
#SBATCH --account=def-juniacke
#SBATCH --job-name=dt_plot
#SBATCH --ntasks-per-node=8
#SBATCH --time=0-03:00:00
#SBATCH --mem-per-cpu=10G
#SBATCH --output=dt_plot.%J.out
#SBATCH --error=dt_plot.%J.err

pip uninstall plotly

module load StdEnv/2020 gcc/9.3.0
module load r-bundle-bioconductor/3.12
module load python/3.8
module load scipy-stack/2020b

#older versions

pip install git+https://github.com/dpryan79/py2bit
pip install pyBigWig
pip install pysam
pip install plotly

pip install deeptools

#dt_plot.sh

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

plotCorrelation -in $output/$name.npz --corMethod spearman --skipZeros --plotTitle "Spearman Correlation of Read Counts" --whatToPlot heatmap --colorMap RdYlBu --plotNumbers -o $output/heatmap_SpearmanCorr_$name.png --outFileCorMatrix $output/SpearmanCorr_$name.tab

