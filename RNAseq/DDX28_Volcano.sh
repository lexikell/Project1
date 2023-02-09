#!/bin/bash
#SBATCH --account=def-juniacke
#SBATCH --job-name=volcanoR
#SBATCH --ntasks-per-node=4
#SBATCH --time=0-03:00:00
#SBATCH --mem-per-cpu=3G
#SBATCH --output=volcano.%J.out
#SBATCH --error=volcano.%J.err

module load StdEnv/2020 gcc/9.3.0 r/4.0.2
module load r-bundle-bioconductor/3.16
module load ggplot2/3.4.0 ggrepel/0.9.2

script DDX_volcano.R

#we can use above script to run a different R script 
#Here we'll try to run a "DDX_volcano.R" script in your bin
