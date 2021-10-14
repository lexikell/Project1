#!/bin/bash
#SBATCH --account=def-juniacke
#SBATCH --job-name=dt_cmatrixplotall
#SBATCH --ntasks=15
#SBATCH --time=0-14:00:00
#SBATCH --mem-per-cpu=40G
#SBATCH --output=dt_cmatrixplotall.%J.out
#SBATCH --error=dt_cmatrixplotall.%J.err

module load StdEnv/2020
module load python/3.9.6
module load scipy-stack/2021a

pip install deeptools

#dt_cmatrixplotall.sh

#download bam gene list from UCSC (not shown here)
#move that gzip to computecan:
#scp /Users/lexikellington/seq/UCSCgenes.bed.gz akelling@cedar.computecanada.ca:/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools
#gunzip that file once in computecanada

ID="18Sept21"
WORKDIR=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools
genes=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools/UCSCgenes.bed
bigwigN="bamcompare_N_""$ID".bw
bigwigH="bamcompare_H_""$ID".bw
bigwig8="bamcompare_8_""$ID".bw
bigwig5="bamcompare_5_""$ID".bw
NC=$WORKDIR/"bamcoverage_NC_""$ID".bw

name="computematrix_all_""$ID".mat.gz
plot="TSSplotScale_all_""$ID"
plot2="TSSplotScale_all_merge""$ID"
plot3="TSSplotScale_all_cluster""$ID"
plot4="TSSplotScale_all_heatmap""$ID"

computeMatrix scale-regions -S $WORKDIR/$bigwigN $WORKDIR/$bigwigH $WORKDIR/$bigwig8 $WORKDIR/$bigwig5 -R $genes \
--beforeRegionStartLength 5000 --regionBodyLength 5000 --afterRegionStartLength 3000 --skipZeros -o $name

#seperate plots
plotProfile -m $name -out $plot.png --numPlotsPerRow 2 --plotTitle "TSS profile"

#1)add color between the x axis and the lines #2)make one image per BED file instead of per bigWig file
plotProfile -m $name -out $plot2.png --plotType=fill --perGroup --colors red yellow blue green purple --plotTitle "TSS profile"

#kmeans clustering and merged
plotProfile -m $name --perGroup --kmeans 2 -out $plot3.png

#heatmap of kmeans clustering
plotProfile -m $name --perGroup --kmeans 2 --plotType heatmap -out $plot4.png

#scp akelling@cedar.computecanada.ca:/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools/TSSplotScale_all_cluster18Sept21.png /Users/lexikellington/seq/deeptools
