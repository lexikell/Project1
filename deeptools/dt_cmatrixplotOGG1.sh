#!/bin/bash
#SBATCH --account=def-juniacke
#SBATCH --job-name=dt_cmatrixplotOGG1
#SBATCH --ntasks=15
#SBATCH --time=0-20:00:00
#SBATCH --mem-per-cpu=9G
#SBATCH --output=dt_cmatrixplotOGG1.%J.out
#SBATCH --error=dt_cmatrixplotOGG1.%J.err

module load StdEnv/2020
module load python/3.9.6
module load scipy-stack/2021a

pip install deeptools

#dt_cmatrixplotOGG1.sh

#1) BAM to bigwig for OGG1 outside data (bamcoverage)
#OGG1 bam
#STOP! Ran out of memory for this whole job. It did complete the bw so let's block out these lines 

#OGG1BAM=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/OutsideData/Hao2018/Hao2018_FLAGOGG1.bam
#blacklist=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/blacklist/hg38-blacklist.bed
#OGG1="bamcoverage_OGG1"

#bamCoverage -b $OGG1BAM -o $OGG1.bw -of bigwig -bl $blacklist

#2) compute matrix & plot 

ID="18Sept21"
WORKDIR=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools
genes=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools/UCSCgenes.bed
bigwigN="bamcompare_N_""$ID".bw
bigwigH="bamcompare_H_""$ID".bw
bigwig8="bamcompare_8_""$ID".bw
bigwig5="bamcompare_5_""$ID".bw
bigwigOGG=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools/other/bamcoverage_OGG1.bw
NC=$WORKDIR/"bamcoverage_NC_""$ID".bw

name="computematrix_OGG1".mat.gz
plot="TSSplotScale_OGG1"
plot2="TSSplotScale_OGG1_merge"
plot3="TSSplotScale_OGG1_cluster"
plot4="TSSplotScale_OGG1_heatmap"

computeMatrix scale-regions -S $WORKDIR/$bigwigN $WORKDIR/$bigwigH $WORKDIR/$bigwig8 $WORKDIR/$bigwig5 $bigwigOGG -R $genes \
--beforeRegionStartLength 5000 --regionBodyLength 1000 --afterRegionStartLength 3000 --skipZeros -o $name --verbose

#seperate plots
plotProfile -m $name -out $plot.png --numPlotsPerRow 2 --plotTitle "TSS profile"

#1)add color between the x axis and the lines #2)make one image per BED file instead of per bigWig file
plotProfile -m $name -out $plot2.png --plotType=fill --perGroup --colors red yellow blue green purple --plotTitle "TSS profile"

#kmeans clustering and merged
plotProfile -m $name --perGroup --kmeans 2 -out $plot3.png

#heatmap of kmeans clustering
plotProfile -m $name --perGroup --kmeans 2 --plotType heatmap -out $plot4.png

scp akelling@cedar.computecanada.ca:/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools/other/TSSplotScale_OGG1_cluster2.png /Users/lexikellington/seq/deeptools

#/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools/other

#/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools/other/computematrix_OGG1.mat.gz