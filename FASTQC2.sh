#!/bin/bash
#SBATCH --account=def-juniacke
#SBATCH --job-name=qc2
#SBATCH --ntasks-per-node=1
#SBATCH --nodes=1
#SBATCH --time=0-00:60:00
#SBATCH --mem-per-cpu=2G
#SBATCH --output=qc2.%J.out
#SBATCH --error=qc2.%J.err

module load StdEnv/2020
module load nixpkgs/16.09
module load fastqc/0.11.9

#fastqc2.sh

for VAR in /home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JUL5_L001_ds.5b4c06c3d6ed406f94794ee03783ecdf/*.fastq.gz
do
    fastqc $VAR -o /home/akelling/projects/def-juniacke/akelling/project_202107/11_QC/rep2
done
for VAR in /home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JUL5_L002_ds.5af0dc9982d24c42be68f83088c49945/*.fastq.gz
do
    fastqc $VAR -o /home/akelling/projects/def-juniacke/akelling/project_202107/11_QC/rep2
done
for VAR in /home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JUL5_L003_ds.fda6283021544a9e983cc0cc70f1ca62/*.fastq.gz
do
    fastqc $VAR -o /home/akelling/projects/def-juniacke/akelling/project_202107/11_QC/rep2
done
for VAR in /home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JUL5_L004_ds.80e002ceff0940a0b6e009ffa486a419/*.fastq.gz
do
    fastqc $VAR -o /home/akelling/projects/def-juniacke/akelling/project_202107/11_QC/rep2
done

for VAR in /home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JUL5IgG_L001_ds.acb40a67d798412ab52535c88fb334dd/*.fastq.gz
do
    fastqc $VAR -o /home/akelling/projects/def-juniacke/akelling/project_202107/11_QC/rep2
done
for VAR in /home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JUL5IgG_L002_ds.14c025ba72e649c8831745d407392d07/*.fastq.gz
do
    fastqc $VAR -o /home/akelling/projects/def-juniacke/akelling/project_202107/11_QC/rep2
done
for VAR in /home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JUL5IgG_L003_ds.cd42b9fb02b44340827ae82444e41f1c/*.fastq.gz
do
    fastqc $VAR -o /home/akelling/projects/def-juniacke/akelling/project_202107/11_QC/rep2
done
for VAR in /home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JUL5IgG_L004_ds.c70ea1a9f8454de3bcb95324700eea1f/*.fastq.gz
do
    fastqc $VAR -o /home/akelling/projects/def-juniacke/akelling/project_202107/11_QC/rep2
done


# ##############################
#then need to scp the files onto your local cmpt to open the HTML through a browser 
#I first made another folder within TEST_fastqc named TEST_fastqc_html with only the .html files so that I didn't copy unnec stuff
#made dir then "mv *.html TEST_fastqc_html

scp -r akelling@cedar.computecanada.ca:/home/akelling/projects/def-juniacke/akelling/project_202107/11_QC/rep2/*_fastqc.html /Users/lexikellington/seq/fastqc_html/rep2

#then "open file.html" and it will open in chrome (bc it's your default browser)