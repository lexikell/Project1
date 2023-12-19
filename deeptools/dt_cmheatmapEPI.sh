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

#dt_cmheatmapEPI.sh

WORKDIR=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools
blacklist=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/blacklist/hg38-blacklist.bed
output=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/18Sept21/deeptools
ID="18Sept21"
name="promoterNP5heatmaprefEPI"

bigwigN="bamcompare_N_""$ID".bw
bigwigH="bamcompare_H_""$ID".bw
bigwig5="bamcompare_5_""$ID".bw
bigwigATAC=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/OutsideData/Karabacak2018/GSM2902628_HEK293_ATAC_medium_depth_bio1_tech1.bw
#ADD bigwig for histone upregulation mark 
#H3K4me3=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/OutsideData/ENCODE/StamatoyannopoulosH3K4me3_ENCFF315TAU.bigWig
#H3K27Ac=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/OutsideData/ENCODE/FarnhamH3K27Ac_ENCFF448INR.bigWig

#HEre is a different heterochr mark bw aligned with Hg19 (which is wrong but I want to test the program)
H3K9me3=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/OutsideData/ENCODE/HattoriH3K9me3_GSM1624503.bigwig

#ADD bigwig for histone downregulation mark
#enhancer mark
#H3K4me1=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/OutsideData/ENCODE/FarnhamH3K4me1_ENCFF285XZL.bigWig

#ERROR: a different assembly? at least that's the warning...? 

promoterbedN=/home/akelling/projects/def-juniacke/akelling/project_202107/30_bioconductor/rep1/chippeakanno/annoIDsNdf_up5000down1000.bed
promoterbed5=/home/akelling/projects/def-juniacke/akelling/project_202107/30_bioconductor/rep1/chippeakanno/annoIDs5df_up5000down1000.bed
promoterbedH=/home/akelling/projects/def-juniacke/akelling/project_202107/30_bioconductor/rep1/chippeakanno/annoIDsHdf_up5000down1000.bed

#use your previously made bigwigs to make the compute matrix 

#maybe each of the bigwigs can be done seperate? the heatmap should just be compared to the bed files anyway 
#sqso as long as everything stays the same this should be fine
computeMatrix reference-point -S $bigwigATAC $H3K9me3 -R $promoterbed5 $promoterbedN \
--beforeRegionStartLength 3000 --afterRegionStartLength 1000 --skipZeros -o $name.gz --verbose

##############
#visualize using plotheatmap
#the kmeans clustering could be nice BUT
    #I don't think I'll be able to do kmeans AND have each N5H curves on the graph 
    # - I think it seperates the heatmaps based on EITHER the bed samples you give OR based on kmeans 
    #so maybe Plan A you seperate based on kmeans but Plan B you seperate based on your N5H beds 

plotHeatmap -m $name.gz -out $name.png


#NOTE
#okay this ran! I had to remove my own bw and it works 
#but the images are still trash - idk how to compare when things just aren't correlating 

#scp akelling@cedar.computecanada.ca:/home/akelling/projects/def-juniacke/akelling/project_202107/40_deeptools/promoterNP5heatmapATAC.png /Users/lexikellington/seq/deeptools

#scp /Users/lexikellington/seq/OutsideData/HattoriH3K9me3_GSM1624503.bigwig akelling@cedar.computecanada.ca:/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/OutsideData/ENCODE
