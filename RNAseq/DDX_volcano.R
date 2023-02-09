#Let's try and use the R and ggplot in compute canada to analyze the TSV files from the DDX28 Graveley dataset (2014)
#following a Volcano plot tutorial from Samuel's Blog (2020)

#downloaded TSV data onto local then moved to CC OutsideData

#scp /Users/lexikellington/Downloads/ENCFF383XBH.tsv akelling@cedar.computecanada.ca:/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/OutsideData/Graveley2014

#if running this script in CC doesn't work then you can just run an interactive job and run the R then 
#but let's try and learn 

R
install.packages("tidyverse", repos="https://mirror.rcg.sfu.ca/mirror/CRAN/")

sed -n '2011p' ENCFF383XBH.tsv