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

#dt_cmatrixplotRNA.sh

#1) compute matrix & plot 

#use compute matrix on dt to compare to the RNA Central ncRNA bam list 
    #use their list instead of the genes bam that you normally compare everything to 
#Here: 5% sample only 
#(maybe next try your 5% sample and an RNAPII sample compared to this?)

ID="18Sept21"
WORKDIR=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools
#genes=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools/UCSCgenes.bed
#bigwigN="bamcompare_N_""$ID".bw
#bigwigH="bamcompare_H_""$ID".bw
#bigwig8="bamcompare_8_""$ID".bw
bigwig5="bamcompare_5_""$ID".bw
#NC=$WORKDIR/"bamcoverage_NC_""$ID".bw

RNACentral=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/OutsideData/RNAcentral/homo_sapiens.GRCh38.bed

name="computematrix_RNAcentral".mat.gz
plot="TSSplotScale_RNAcentral"
plot2="TSSplotScale_RNAcentral_merge"
plot3="TSSplotScale_RNAcentral_cluster"
plot4="TSSplotScale_RNAcentral_heatmap"

computeMatrix scale-regions -S $WORKDIR/$bigwig5 -R $RNACentral \
--beforeRegionStartLength 5000 --regionBodyLength 500 --afterRegionStartLength 3000 --skipZeros -o $name --verbose

#seperate plots
plotProfile -m $name -out $plot.png --numPlotsPerRow 2 --plotTitle "TSS profile"

#1)add color between the x axis and the lines #2)make one image per BED file instead of per bigWig file
plotProfile -m $name -out $plot2.png --plotType=fill --perGroup --colors red yellow blue green purple --plotTitle "TSS profile"

#kmeans clustering and merged
plotProfile -m $name --perGroup --kmeans 2 -out $plot3.png

#heatmap of kmeans clustering
plotProfile -m $name --perGroup --kmeans 2 --plotType heatmap -out $plot4.png

#scp akelling@cedar.computecanada.ca:/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools/other/TSSplotScale_OGG1_cluster2.png /Users/lexikellington/seq/deeptools

#After running for 15h, this was an oom_kill event - out of memory 