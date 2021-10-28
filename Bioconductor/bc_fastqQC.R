#!/bin/bash
#SBATCH --account=def-juniacke
#SBATCH --job-name=bc_
#SBATCH --ntasks=15
#SBATCH --time=0-14:00:00
#SBATCH --mem-per-cpu=40G
#SBATCH --output=bc_.%J.out
#SBATCH --error=bc_.%J.err

#from "R Bioinformatics Reading fastq with bioconductor" Rob H YouTube

#manually loaded:
module load StdEnv/2020 gcc/9.3.0
module load r/4.1.0
module load r-bundle-bioconductor/3.12

#to run R in your linux terminal:
# > "R"
#now you can use R language. To quit "q()"

library(ShortRead)
library(ggplot2)

#he then downloaded a fastq file from an SRR file. You're going to use one of your files
#your files are too big, so to do this it'll have to be a script to send to slurm

#read fastq file into envi:
#this uses readFastq which is a command/function built within the ShortRead library you loaded above
#you just have to point it to your fastq file
fq = readFastq( 'PAbJUL1_S1_L001_R1_001.fastq' )

head(fq)
#his output gives the cycles (seq length) of the first couple lines
summary(fq)
#this output is the number of reads in the file

#look at DNA sequences. Two columns: the sequencing length and the string of NT calls
reads = sread(fq)
head(reads)
#this should show a colour coded NT view of the first 6 reads
#next you want to see how long each seq read is. In readFastq, they call these "widths". 
#This is the first column in your table that you saw above in "reads".
#so we're going to take this column and make it into a vector of values of the sequencing read lengths
widths = reads@ranges@width
#view
widths
#instead of a vector, let's make it accessible to ggplot in order to plot this read length data
widths = as.data.frame(reads@ranges@width)

ggplot(widths) + 
    geom_histogram(aes(x=reads@ranges@width))

#when above is run, the output graph is seen under "plots" in the bottom right of Rstudio (idk how you would see in compute can..?)
#this histogram should show the read length of the illumina run

#graph the quality scores
#uses the "quality" function in the ShortRead library to pull those from the fastq files
quals = quality(fq)
head(quals)
#Shoud show the width (seq read length) and the string of quality ASCII scores (aka useless to you LOL unless you want that table for something?)
#review: letters good, symbols bad quality lol

#average qaulity score (in numeric value)
#first, convert the ASCII scores to their numerical scores in a matrix:
numqscores = as(quals, 'matrix')
#then get the average of each row and plot that with ggplot:
avgscore = rowMeans(numqscores, na.rm = T)
#^bc we made a matrix, each row is as long as the longest read in the matrix. This means there will be NA calls for the shorter reads compared to that longer one. So we add the arguement "na.rm=TRUE" to remove any NA values so that it doesn't mess with our average calculations later
avgscore = as.data.frame(avgscore)
ggplot(avgscore) +
    geom_histogram(aes(x=avgscore))

#You want most of your reads to have the higher end of the histogram (higher quality)