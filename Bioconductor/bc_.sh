#!/bin/bash
#SBATCH --account=def-juniacke
#SBATCH --job-name=bc_
#SBATCH --ntasks=15
#SBATCH --time=0-14:00:00
#SBATCH --mem-per-cpu=40G
#SBATCH --output=bc_.%J.out
#SBATCH --error=bc_.%J.err

module load StdEnv/2020 gcc/9.3.0
module load r/4.1.0
module load r-bundle-bioconductor/3.12

#bc_?.sh
#bioconductor (R packages from bioinformaticians)

#to run R in your linux terminal:
# > "R"
#now you can use R language. To quit "q()"

