#!/bin/bash
#SBATCH --account=def-juniacke
#SBATCH --job-name=dt_bamcorr
#SBATCH --ntasks-per-node=8
#SBATCH --time=0-06:00:00
#SBATCH --mem-per-cpu=15G
#SBATCH --output=BwaMem.%J.out
#SBATCH --error=BwaMem.%J.err

module load scipy-stack/2021a
module load numpy/1.21.0 scipy/1.7.0
pip install deeptools

pip install git+https://github.com/dpryan79/py2bit
pip install pyBigWig
pip install pysam
module load matplotlib/3.4.2

#^install deeptools
#correlate bam files using DeepTools MultiBamSummary and plotCorrelation tools 

multiBamSummary bins --bamfiles file1.bam file2.bam -o results.npz

#AND ALSO ADD THE GRAPH ONE TOO?