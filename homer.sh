#!/bin/bash
#SBATCH --account=def-juniacke
#SBATCH --job-name=homer
#SBATCH --ntasks-per-node=3
#SBATCH --time=0-00:50:00
#SBATCH --mem-per-cpu=3G
#SBATCH --output=homer.%J.out
#SBATCH --error=homer.%J.err


mkdir homer
cd homer/
wget http://homer.ucsd.edu/homer/configureHomer.pl
module load perl
perl configureHomer.pl -install
#and also added to PATH 
#find path file 
find ~ -name .bash_profile
#edit PATH
#?
#update PATH
source ~/.bash_profile

#really just downloaded according to the homer instructions online 

#try first with an interactive node:
#salloc --time=0:70:0 --ntasks=2 --account=def-juniacke

#and then installed their files for hg38 (which didn't work) and Hg19
perl /home/akelling/projects/def-juniacke/akelling/project_202107/50_HOMER/configureHomer.pl -install hg19
#this one refreshes the download to the latest update 
perl /home/akelling/projects/def-juniacke/akelling/project_202107/50_HOMER/configureHomer.pl -configure

#FILE FIX
# Replace commas with tabs in the file
sed 's/,/\t/g' annoIDs5df_up5000down1000HOMER.csv > annoIDs5df_up5000down1000HOMER.bed
sed 's/"//g' annoIDs5df_up5000down1000HOMER.bed > annoIDs5df_up5000down1000HOMERNEW.bed
#your HOMER files that you made have quotes in them! Get rid of them 
sed 's/"//g' annoIDsHdf_up5000down1000HOMER.bed > annoIDs5df_up5000down1000HOMERNEW.bed


#homer needs a folder to put things in 
mkdir preparsed 
#and you need to point to this folder directly in the running line
findMotifsGenome.pl annoIDs5df_up5000down1000HOMERNEW.bed hg19 5_output5 -preparsedDir /home/akelling/projects/def-juniacke/akelling/project_202107/50_HOMER/preparsed -preparse


#OOPS I MADE AN OOPS
findMotifsGenome.pl annoIDsHdf_up5000down1000HOMERNEW.bed hg19 N_output -preparsedDir /home/akelling/projects/def-juniacke/akelling/project_202107/50_HOMER/preparsed -preparse
#This is in "N_output" but it is the H file so it's renamed on your local but not when you open the file 

findMotifsGenome.pl annoIDsNdf_up5000down1000HOMERNEW.bed hg19 N_output1 -preparsedDir /home/akelling/projects/def-juniacke/akelling/project_202107/50_HOMER/preparsed -preparse


#onto local to visualize 
scp akelling@cedar.computecanada.ca:/home/akelling/projects/def-juniacke/akelling/project_202107/50_HOMER/N_output1/knownResults.html /Users/lexikellington/seq/homer
