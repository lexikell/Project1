#!/bin/bash
#SBATCH --account=def-juniacke
#SBATCH --job-name=dt_plotprofile
#SBATCH --ntasks=15
#SBATCH --time=0-00:40:00
#SBATCH --mem-per-cpu=15G
#SBATCH --output=dt_plotprofile.%J.out
#SBATCH --error=dt_plotprofile.%J.err

module load StdEnv/2020
module load python/3.9.6
module load scipy-stack/2021a

pip install deeptools

#dt_plotprofile.sh

ID="18Sept21"
WORKDIR=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools
genes=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools/UCSCgenes.bed

name="computematrix_all_""$ID".mat.gz
heatmap="TSSmatrix_all_""$ID"
plot="TSSplot_all_""$ID"
plot2="TSSplot_all_merge""$ID"
plot3="TSSplot_all_cluster""$ID"
plot4="TSSplot_all_heatmap""$ID"

#seperate plots
plotProfile -m $name -out $plot.png --numPlotsPerRow 2 --plotTitle "TSS profile"

#1)add color between the x axis and the lines #2)make one image per BED file instead of per bigWig file
plotProfile -m $name -out $plot2.png --plotType=fill --perGroup --colors red yellow blue green purple --plotTitle "TSS profile"

#kmeans clustering and merged
plotProfile -m $name --perGroup --kmeans 2 -out $plot3.png

#heatmap of kmeans clustering
plotProfile -m $name --perGroup --kmeans 2 --plotType heatmap -out $plot4.png

#scp akelling@cedar.computecanada.ca:/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools/TSSplot_all_merge18Sept21.png /Users/lexikellington/seq/deeptools

#TSSplot_all_cluster18Sept21.png
#TSSplot_all_merge18Sept21.png