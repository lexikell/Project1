#!/bin/bash
#SBATCH --account=def-juniacke
#SBATCH --job-name=dt_bwsum
#SBATCH --ntasks-per-node=8
#SBATCH --time=0-01:30:00
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

#dt_bwsum_NHPG4.sh

#compare the G4 ChIP bigwig file from Lago (2021, Nature) to your samples
#could also add other bigwigs to compare (methyls? Pol2?)

#the rep1 files that you converted to bigwig already:
#/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools/bamcompare_N_18Sept21.bw
#rep2 bw files:
#/home/akelling/projects/def-juniacke/akelling/project_202107/20_aligned/deeptools/bamcompare_N_1Apr22.bw

#download GEO data from the NCBI repository:
#use the GEO FTP site to find file link (many online tutorials exist)
#Make new dir with paper as name and navigate there
#> cd /home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/OutsideData/Lago2021
#then use wget when you're in that directory
#> wget --recursive --no-parent -nd ftp://ftp.ncbi.nlm.nih.gov/geo/series/GSE145nnn/GSE145543/suppl/
#this was a tar file, which had to be unzipped
#> tar -xvf GSE145543_RAW.tar

ID="19Jul22"
WORKDIR=/home/akelling/projects/def-juniacke/akelling/project_202107/20_aligned/deeptools/19Jul22
#G4 ChIP from Lago 2021 Nature
G4=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/OutsideData/Lago2021/GSM4320546_ChIPseq_IP_BG4_93T449_m1.bigWig
#N and N IgG
Nr1=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools/bamcompare_N_18Sept21.bw
S1=/home/akelling/projects/def-juniacke/akelling/project_202107/20_aligned/deeptools/bamcompare_N_1Apr22.bw
NC=/home/akelling/projects/def-juniacke/akelling/project_202107/20_aligned/deeptools/bamcoverage_NC_1Apr22.bw

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
output=/home/akelling/projects/def-juniacke/akelling/project_202107/20_aligned/deeptools/19Jul22
name="multibwsum_NG4_""$ID"

#correlate bigwig files using DeepTools MultiBigwigSummary and plotCorrelation tools 
multiBigwigSummary bins -b $Nr1 $S1 $NC $G4 --labels Normoxiar1 Normoxiar2 IgG G4 --blackListFileName $blacklist -o $output/$name.npz

#and graphs? might have to uninstall the R package again (but we added on top so idk)
plotCorrelation -in $output/$name.npz --corMethod spearman --skipZeros --plotTitle "Spearman Correlation of Read Counts" \
--whatToPlot heatmap --colorMap RdYlGn --plotNumbers -o $output/heatmap_$name.png --outFileCorMatrix $output/SpearmanCorr_$name.tab

#scatterplot too
plotCorrelation -in $output/$name.npz --corMethod spearman --skipZeros --plotTitle "Pearson Correlation of Average Scores Per Transcript" \
--whatToPlot scatterplot -o $output/scatterplot_$name.png

#Move images to local
#scp akelling@cedar.computecanada.ca:/home/akelling/projects/def-juniacke/akelling/project_202107/20_aligned/deeptools/19Jul22/scatterplot_multibwsum_NG4_19Jul22.png /Users/lexikellington/seq/deeptools/19Jul22

#MOVED GENE LIST TO local
#- run gene list through upset graph next to NHP gene list
#- add G4 gene list to excel list? 
#- make ppt with failed graphs and new upset graph 
#- whats this enhancer list?