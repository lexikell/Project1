#!/bin/bash
#SBATCH --account=def-juniacke
#SBATCH --job-name=dt_bamcoverage
#SBATCH --ntasks-per-node=15
#SBATCH --time=0-05:00:00
#SBATCH --mem-per-cpu=5G
#SBATCH --output=dt_bamcoverage.%J.out
#SBATCH --error=dt_bamcoverage.%J.err

module load StdEnv/2020
module load python/3.9.6
module load scipy-stack/2021a

pip install deeptools

#dt_bamcoverage.sh

ID="1Apr22"
WORKDIR=/home/akelling/projects/def-juniacke/akelling/project_202107/20_aligned
#N and N IgG
S1=$WORKDIR/"JULN""_""$ID".bam
C1=$WORKDIR/"JULNIgG""_""$ID".bam
#H and H IgG
S2=$WORKDIR/"JULH""_""$ID".bam
C2=$WORKDIR/"JULHIgG""_""$ID".bam
#8% and 8% IgG
S3=$WORKDIR/"JUL8""_""$ID".bam
C3=$WORKDIR/"JUL8IgG""_""$ID".bam
#5% and 5% IgG
S4=$WORKDIR/"JUL5""_""$ID".bam
C4=/home/akelling/projects/def-juniacke/akelling/project_202107/20_aligned/JUL5IgG_1Apr22.bam

blacklist=/home/akelling/projects/def-juniacke/akelling/Data1/2I7I3XE/KEL17000.20210603/210602_A00481_0206_AHFM2CDRXY/blacklist/hg38-blacklist.bed
output=/home/akelling/projects/def-juniacke/akelling/project_202107/20_aligned/deeptools

name1="bamcoverage_NC_""$ID"
bamCoverage -b $C1 -o $name1.bw -of bigwig -bl $blacklist

name2="bamcoverage_HC_""$ID"
bamCoverage -b $C2 -o $name2.bw -of bigwig -bl $blacklist

name3="bamcoverage_8C_""$ID"
bamCoverage -b $C3 -o $name3.bw -of bigwig -bl $blacklist

name4="bamcoverage_5C_""$ID"
bamCoverage -b $C4 -o $name4.bw -of bigwig -bl $blacklist


#The file '/home/akelling/projects/def-juniacke/akelling/project_202107/20_aligned/JUL5IgG_1Apr22.bam' does not exist
#The file '/home/akelling/projects/def-juniacke/akelling/project_202107/20_aligned/JUL5IgG_1Apr22.bam' does not exist
#The file '/home/akelling/projects/def-juniacke/akelling/project_202107/20_aligned/JUL5IgG_1Apr22.bam' does not exist
#The file '/home/akelling/projects/def-juniacke/akelling/project_202107/20_aligned/JUL5IgG_1Apr22.bam' does not exist
#so both the coverage and compare did not work for JUL5 because the 5IgG doesn't exist? ^^
#you renamed the 5IgG bam and sams to "22Apr22"
#PlanB: ON running the bwa for 5IgG again to see
    #PlanC: otherwise try merging the 5IgG 4 files again and THEN doing the bwa for it again
    #PlanD: Jeff