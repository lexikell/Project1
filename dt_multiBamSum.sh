#!/bin/bash
#SBATCH --account=def-juniacke
#SBATCH --job-name=dt_bamcorr
#SBATCH --ntasks-per-node=8
#SBATCH --time=0-06:00:00
#SBATCH --mem-per-cpu=15G
#SBATCH --output=dt_bamcorr.%J.out
#SBATCH --error=dt_bamcorr.%J.err

module load StdEnv/2020
module load python/3.9.6
module load scipy-stack/2021a

pip install git+https://github.com/dpryan79/py2bit
pip install pyBigWig
pip install pysam
module load matplotlib/3.4.2
pip install deeptools

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

deepTools2.0/bin/multiBamSummary bins --bamfiles $S1 $S2 $S3 $S4 $C1 --labels Normoxia Hypoxia Physioxia8 Physioxia5 IgG --blackListFileName $blacklist -o $output/$name.npz

#AND ALSO ADD THE GRAPH ONE TOO?:

deepTools2.0/bin/plotCorrelation -in $output/$name.npz --corMethod spearman --skipZeros --plotTitle "Spearman Correlation of Read Counts" \
    --whatToPlot heatmap --colorMap RdYlBu --plotNumbers \
    -o $output/heatmap_SpearmanCorr_$name.png   \
    --outFileCorMatrix $output/SpearmanCorr_$name.tab