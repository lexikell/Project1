#!/bin/bash
#SBATCH --account=def-juniacke
#SBATCH --job-name=dt_cmatrixplot
#SBATCH --ntasks=15
#SBATCH --time=0-00:30:00
#SBATCH --mem-per-cpu=2G
#SBATCH --output=dt_cmatrixplot.%J.out
#SBATCH --error=dt_cmatrixplot.%J.err

module load StdEnv/2020
module load python/3.9.6
module load scipy-stack/2021a
pip install deeptools

#some of this is from "dt_cmatrixplotATAC.sh" 
    #I deleted the control bw because I wouldn't want this in the graph 
    #also compared to that, I deleted "genes" bc that's all genes but I want just my N5H ones 
    #although idk why I'm using this one cause this never worked LOL
ID="18Sept21"
WORKDIR=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools
blacklist=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/blacklist/hg38-blacklist.bed
output=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools

name="promoterheatmapPLANB"

bigwigN="bamcompare_N_""$ID".bw
bigwigH="bamcompare_H_""$ID".bw
bigwig5="bamcompare_5_""$ID".bw
#bigwigATAC=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/OutsideData/Karabacak2018/GSM2902628_HEK293_ATAC_medium_depth_bio1_tech1.bw
#ADD bigwig for histone upregulation mark 
#ADD bigwig for histone downregulation mark

promoterbedN=/home/akelling/projects/def-juniacke/akelling/project_202107/30_bioconductor/rep1/chippeakanno/annoIDsNdf_up5000down1000.bed
promoterbed5=/home/akelling/projects/def-juniacke/akelling/project_202107/30_bioconductor/rep1/chippeakanno/annoIDs5df_up5000down1000.bed
promoterbedH=/home/akelling/projects/def-juniacke/akelling/project_202107/30_bioconductor/rep1/chippeakanno/annoIDsHdf_up5000down1000.bed

#use your previously made bigwigs to make the compute matrix 

#maybe each of the bigwigs can be done seperate? the heatmap should just be compared to the bed files anyway 
#sqso as long as everything stays the same this should be fine
computeMatrix scale-regions -S $WORKDIR/$bigwig5 -R $promoterbed5 $promoterbedH \
--beforeRegionStartLength 3000 --regionBodyLength 1000 --afterRegionStartLength 3000 --skipZeros -o $name.gz --verbose

#Use this one after if 1 sample works 
#computeMatrix scale-regions -S $WORKDIR/$bigwigN $WORKDIR/$bigwig5 $WORKDIR/$bigwigH $bigwigATAC -R $promoterbedN $promoterbed5 $promoterbedH \
#--beforeRegionStartLength 5000 --regionBodyLength 1000 --afterRegionStartLength 3000 --skipZeros -o $name --verbose

##############
#visualize using plotheatmap
#the kmeans clustering could be nice BUT
    #I don't think I'll be able to do kmeans AND have each N5H curves on the graph 
    # - I think it seperates the heatmaps based on EITHER the bed samples you give OR based on kmeans 
    #so maybe Plan A you seperate based on kmeans but Plan B you seperate based on your N5H beds 

plotHeatmap -m $name.gz -out $name.png

#scp akelling@cedar.computecanada.ca:/home/akelling/projects/def-juniacke/akelling/project_202107/40_deeptools/promoterheatmapPLANB.png /Users/lexikellington/seq/deeptools
