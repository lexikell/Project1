#!/bin/bash
#SBATCH --account=def-juniacke
#SBATCH --job-name=dt_cmatrixplot
#SBATCH --ntasks=15
#SBATCH --time=0-20:00:00
#SBATCH --mem-per-cpu=9G
#SBATCH --output=dt_cmatrixplot.%J.out
#SBATCH --error=dt_cmatrixplot.%J.err

module load StdEnv/2020
module load python/3.9.6
module load scipy-stack/2021a

pip install deeptools

#dt_cmatrixplotOGG1.sh

#1) bigwig for ATAC outside data
#ATAC data from HEK293 
#scp /Users/lexikellington/Downloads/GSM2902628_HEK293_ATAC_medium_depth_bio1_tech1.bw akelling@cedar.computecanada.ca:/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/OutsideData/Karabacak2018

#2) compute matrix & plot 

ID="18Sept21"
WORKDIR=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools
genes=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools/UCSCgenes.bed
bigwigN="bamcompare_N_""$ID".bw
bigwigH="bamcompare_H_""$ID".bw
bigwig8="bamcompare_8_""$ID".bw
bigwig5="bamcompare_5_""$ID".bw
bigwigATAC=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/OutsideData/Karabacak2018/GSM2902628_HEK293_ATAC_medium_depth_bio1_tech1.bw
NC=$WORKDIR/"bamcoverage_NC_""$ID".bw

name="computematrix_ATAC".mat.gz
plot="TSSplotScale_ATAC"
plot2="TSSplotScale_ATAC_merge"
plot3="TSSplotScale_ATAC_cluster"
plot4="TSSplotScale_ATAC_heatmap"

computeMatrix scale-regions -S $WORKDIR/$bigwigN $WORKDIR/$bigwigH $WORKDIR/$bigwig8 $WORKDIR/$bigwig5 $bigwigATAC -R $genes \
--beforeRegionStartLength 5000 --regionBodyLength 1000 --afterRegionStartLength 3000 --skipZeros -o $name --verbose

#seperate plots
plotProfile -m $name -out $plot.png --numPlotsPerRow 2 --plotTitle "TSS profile"

#1)add color between the x axis and the lines #2)make one image per BED file instead of per bigWig file
plotProfile -m $name -out $plot2.png --plotType=fill --perGroup --colors red yellow blue green purple --plotTitle "TSS profile"

#kmeans clustering and merged
plotProfile -m $name --perGroup --kmeans 2 -out $plot3.png

#heatmap of kmeans clustering
plotProfile -m $name --perGroup --kmeans 2 --plotType heatmap -out $plot4.png

#scp akelling@cedar.computecanada.ca:/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools/other/TSSplotScale_OGG1_cluster2.png /Users/lexikellington/seq/deeptools

