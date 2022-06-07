#!/bin/bash
#SBATCH --account=def-juniacke
#SBATCH --job-name=Bwa_Sam
#SBATCH --ntasks-per-node=8
#SBATCH --time=0-06:00:00
#SBATCH --mem-per-cpu=15G
#SBATCH --output=BwaMem.%J.out
#SBATCH --error=BwaMem.%J.err

#pre-bwa_v6_2.sh
#!! not actually run as a script - just hand command

#Rep2 = 111021AKellington
#   /home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington
#   - 8 samples; each in 4 lanes; each lane has 2 reads
#   - seperate QC
#   - each sample: cat the 4 R1 gzips together (and same for R2s)

JULNR1_1=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JULN_L001_ds.d6f14a6f2a1c4806a1433ea893862f8e/JULN_S138_L001_R1_001.fastq.gz
JULNR1_2=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JULN_L002_ds.402e6377ce7c401bb22e0c4a7781a82f/JULN_S138_L002_R1_001.fastq.gz
JULNR1_3=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JULN_L003_ds.7de0e6a885f946ef9abd266e1e496e0c/JULN_S138_L003_R1_001.fastq.gz
JULNR1_4=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JULN_L004_ds.7c56ca7526d9403eada04fa52397336b/JULN_S138_L004_R1_001.fastq.gz
#check that the variable was named
zcat $JULNR1_1 | head -n 1
zcat $JULNR1_2 | head -n 1
zcat $JULNR1_3 | head -n 1
zcat $JULNR1_4 | head -n 1
cat $JULNR1_1 $JULNR1_2 $JULNR1_3 $JULNR1_4 > JULN_R1merge.fastq.gz
JULNR2_1=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JULN_L001_ds.d6f14a6f2a1c4806a1433ea893862f8e/JULN_S138_L001_R2_001.fastq.gz
JULNR2_2=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JULN_L002_ds.402e6377ce7c401bb22e0c4a7781a82f/JULN_S138_L002_R2_001.fastq.gz
JULNR2_3=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JULN_L003_ds.7de0e6a885f946ef9abd266e1e496e0c/JULN_S138_L003_R2_001.fastq.gz
JULNR2_4=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JULN_L004_ds.7c56ca7526d9403eada04fa52397336b/JULN_S138_L004_R2_001.fastq.gz
zcat $JULNR2_1 | head -n 1
zcat $JULNR2_2 | head -n 1
zcat $JULNR2_3 | head -n 1
zcat $JULNR2_4 | head -n 1
cat $JULNR2_1 $JULNR2_2 $JULNR2_3 $JULNR2_4 > JULN_R2merge.fastq.gz
####IgG
JULNIgGR1_1=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JULNIgG_L001_ds.16527ce501814c959ea9ca6e5cb3a81d/JULNIgG_S139_L001_R1_001.fastq.gz
JULNIgGR1_2=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JULNIgG_L002_ds.ef5e85c24a104899bc99a2e2d0b90297/JULNIgG_S139_L002_R1_001.fastq.gz
JULNIgGR1_3=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JULNIgG_L003_ds.fb8c114d71994165be8d5b73d84f785d/JULNIgG_S139_L003_R1_001.fastq.gz
JULNIgGR1_4=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JULNIgG_L004_ds.ac47fc129c5746c9aeb29c6121cec2eb/JULNIgG_S139_L004_R1_001.fastq.gz
zcat $JULNIgGR1_1 | head -n 1
zcat $JULNIgGR1_2 | head -n 1
zcat $JULNIgGR1_3 | head -n 1
zcat $JULNIgGR1_4 | head -n 1
cat $JULNIgGR1_1 $JULNIgGR1_2 $JULNIgGR1_3 $JULNIgGR1_4 > JULNIgG_R1merge.fastq.gz
JULNIgGR2_1=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JULNIgG_L001_ds.16527ce501814c959ea9ca6e5cb3a81d/JULNIgG_S139_L001_R2_001.fastq.gz
JULNIgGR2_2=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JULNIgG_L002_ds.ef5e85c24a104899bc99a2e2d0b90297/JULNIgG_S139_L002_R2_001.fastq.gz
JULNIgGR2_3=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JULNIgG_L003_ds.fb8c114d71994165be8d5b73d84f785d/JULNIgG_S139_L003_R2_001.fastq.gz
JULNIgGR2_4=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JULNIgG_L004_ds.ac47fc129c5746c9aeb29c6121cec2eb/JULNIgG_S139_L004_R2_001.fastq.gz
zcat $JULNIgGR2_1 | head -n 1
zcat $JULNIgGR2_2 | head -n 1
zcat $JULNIgGR2_3 | head -n 1
zcat $JULNIgGR2_4 | head -n 1
cat $JULNIgGR2_1 $JULNIgGR2_2 $JULNIgGR2_3 $JULNIgGR2_4 > JULNIgG_R2merge.fastq.gz

#################
#H
JULHR1_1=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JULH_L001_ds.986cd8ea15584eb99b1790bc5401de0c/JULH_S140_L001_R1_001.fastq.gz
JULHR1_2=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JULH_L002_ds.ad36c61ea2d64c4c951088fc1752011e/JULH_S140_L002_R1_001.fastq.gz
JULHR1_3=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JULH_L003_ds.8877bf2b71e64c5ea21e95036fc471d3/JULH_S140_L003_R1_001.fastq.gz
JULHR1_4=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JULH_L004_ds.29fbc429e6504b338d0fd714ace35e82/JULH_S140_L004_R1_001.fastq.gz
zcat $JULHR1_1 | head -n 1
zcat $JULHR1_2 | head -n 1
zcat $JULHR1_3 | head -n 1
zcat $JULHR1_4 | head -n 1
cat $JULHR1_1 $JULHR1_2 $JULHR1_3 $JULHR1_4 > JULH_R1merge.fastq.gz

JULHR2_1=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JULH_L001_ds.986cd8ea15584eb99b1790bc5401de0c/JULH_S140_L001_R2_001.fastq.gz
JULHR2_2=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JULH_L002_ds.ad36c61ea2d64c4c951088fc1752011e/JULH_S140_L002_R2_001.fastq.gz
JULHR2_3=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JULH_L003_ds.8877bf2b71e64c5ea21e95036fc471d3/JULH_S140_L003_R2_001.fastq.gz
JULHR2_4=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JULH_L004_ds.29fbc429e6504b338d0fd714ace35e82/JULH_S140_L004_R2_001.fastq.gz
zcat $JULHR2_1 | head -n 1
zcat $JULHR2_2 | head -n 1
zcat $JULHR2_3 | head -n 1
zcat $JULHR2_4 | head -n 1
cat $JULHR2_1 $JULHR2_2 $JULHR2_3 $JULHR2_4 > JULH_R2merge.fastq.gz
####IgG
JULHIgGR1_1=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JULHIgG_L001_ds.5a69b72ad60e4d5197ebb9163867c33d/JULHIgG_S141_L001_R1_001.fastq.gz
JULHIgGR1_2=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JULHIgG_L002_ds.1cde2e5b864b4bf0a70d48dbdc6bd388/JULHIgG_S141_L002_R1_001.fastq.gz
JULHIgGR1_3=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JULHIgG_L003_ds.b2945d6c10f04f75b902d7ac75c8243d/JULHIgG_S141_L003_R1_001.fastq.gz
JULHIgGR1_4=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JULHIgG_L004_ds.6fa0828464344481ae947f1c7c6291e3/JULHIgG_S141_L004_R1_001.fastq.gz
zcat $JULHIgGR1_1 | head -n 1
zcat $JULHIgGR1_2 | head -n 1
zcat $JULHIgGR1_3 | head -n 1
zcat $JULHIgGR1_4 | head -n 1
cat $JULHIgGR1_1 $JULHIgGR1_2 $JULHIgGR1_3 $JULHIgGR1_4 > JULHIgG_R1merge.fastq.gz
#
JULHIgGR2_1=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JULHIgG_L001_ds.5a69b72ad60e4d5197ebb9163867c33d/JULHIgG_S141_L001_R2_001.fastq.gz
JULHIgGR2_2=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JULHIgG_L002_ds.1cde2e5b864b4bf0a70d48dbdc6bd388/JULHIgG_S141_L002_R2_001.fastq.gz
JULHIgGR2_3=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JULHIgG_L003_ds.b2945d6c10f04f75b902d7ac75c8243d/JULHIgG_S141_L003_R2_001.fastq.gz
JULHIgGR2_4=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JULHIgG_L004_ds.6fa0828464344481ae947f1c7c6291e3/JULHIgG_S141_L004_R2_001.fastq.gz
zcat $JULHIgGR2_1 | head -n 1
zcat $JULHIgGR2_2 | head -n 1
zcat $JULHIgGR2_3 | head -n 1
zcat $JULHIgGR2_4 | head -n 1
cat $JULHIgGR2_1 $JULHIgGR2_2 $JULHIgGR2_3 $JULHIgGR2_4 > JULHIgG_R2merge.fastq.gz

################
#8
JUL8R1_1=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JUL8_L001_ds.0f97c17a56a44cdabb26265c6dd0a60a/JUL8_S142_L001_R1_001.fastq.gz
JUL8R1_2=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JUL8_L002_ds.84f996b22cd34d84bd325a4b9048d8fc/JUL8_S142_L002_R1_001.fastq.gz
JUL8R1_3=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JUL8_L003_ds.69b3e05db1954a8eafae56031a331138/JUL8_S142_L003_R1_001.fastq.gz
JUL8R1_4=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JUL8_L004_ds.d8b02a00c65045878c3791eddb3c6b59/JUL8_S142_L004_R1_001.fastq.gz
zcat $JUL8R1_1 | head -n 1
zcat $JUL8R1_2 | head -n 1
zcat $JUL8R1_3 | head -n 1
zcat $JUL8R1_4 | head -n 1
cat $JUL8R1_1 $JUL8R1_2 $JUL8R1_3 $JUL8R1_4 > JUL8_R1merge.fastq.gz
JUL8R2_1=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JUL8_L001_ds.0f97c17a56a44cdabb26265c6dd0a60a/JUL8_S142_L001_R2_001.fastq.gz
JUL8R2_2=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JUL8_L002_ds.84f996b22cd34d84bd325a4b9048d8fc/JUL8_S142_L002_R2_001.fastq.gz
JUL8R2_3=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JUL8_L003_ds.69b3e05db1954a8eafae56031a331138/JUL8_S142_L003_R2_001.fastq.gz
JUL8R2_4=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JUL8_L004_ds.d8b02a00c65045878c3791eddb3c6b59/JUL8_S142_L004_R2_001.fastq.gz
zcat $JUL8R2_1 | head -n 1
zcat $JUL8R2_2 | head -n 1
zcat $JUL8R2_3 | head -n 1
zcat $JUL8R2_4 | head -n 1
cat $JUL8R2_1 $JUL8R2_2 $JUL8R2_3 $JUL8R2_4 > JUL8_R2merge.fastq.gz
####IgG
JUL8IgGR1_1=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JUL8IgG_L001_ds.d8a682e923d64c56a89d3982d2a4c6ac/JUL8IgG_S143_L001_R1_001.fastq.gz
JUL8IgGR1_2=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JUL8IgG_L002_ds.e4c5b872c8774c93afff49104bb889bf/JUL8IgG_S143_L002_R1_001.fastq.gz
JUL8IgGR1_3=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JUL8IgG_L003_ds.51b3998ee775495d8a26f817de1e0beb/JUL8IgG_S143_L003_R1_001.fastq.gz
JUL8IgGR1_4=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JUL8IgG_L004_ds.732c37670c4c4b528abf10c2ae66b365/JUL8IgG_S143_L004_R1_001.fastq.gz
zcat $JUL8IgGR1_1 | head -n 1
zcat $JUL8IgGR1_2 | head -n 1
zcat $JUL8IgGR1_3 | head -n 1
zcat $JUL8IgGR1_4 | head -n 1
cat $JUL8IgGR1_1 $JUL8IgGR1_2 $JUL8IgGR1_3 $JUL8IgGR1_4 > JUL8IgG_R1merge.fastq.gz
#
JUL8IgGR2_1=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JUL8IgG_L001_ds.d8a682e923d64c56a89d3982d2a4c6ac/JUL8IgG_S143_L001_R2_001.fastq.gz
JUL8IgGR2_2=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JUL8IgG_L002_ds.e4c5b872c8774c93afff49104bb889bf/JUL8IgG_S143_L002_R2_001.fastq.gz
JUL8IgGR2_3=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JUL8IgG_L003_ds.51b3998ee775495d8a26f817de1e0beb/JUL8IgG_S143_L003_R2_001.fastq.gz
JUL8IgGR2_4=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JUL8IgG_L004_ds.732c37670c4c4b528abf10c2ae66b365/JUL8IgG_S143_L004_R2_001.fastq.gz
zcat $JUL8IgGR2_1 | head -n 1
zcat $JUL8IgGR2_2 | head -n 1
zcat $JUL8IgGR2_3 | head -n 1
zcat $JUL8IgGR2_4 | head -n 1
cat $JUL8IgGR2_1 $JUL8IgGR2_2 $JUL8IgGR2_3 $JUL8IgGR2_4 > JUL8IgG_R2merge.fastq.gz


################
#5
JUL5R1_1=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JUL5_L001_ds.5b4c06c3d6ed406f94794ee03783ecdf/JUL5_S144_L001_R1_001.fastq.gz
JUL5R1_2=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JUL5_L002_ds.5af0dc9982d24c42be68f83088c49945/JUL5_S144_L002_R1_001.fastq.gz
JUL5R1_3=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JUL5_L003_ds.fda6283021544a9e983cc0cc70f1ca62/JUL5_S144_L003_R1_001.fastq.gz
JUL5R1_4=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JUL5_L004_ds.80e002ceff0940a0b6e009ffa486a419/JUL5_S144_L004_R1_001.fastq.gz
zcat $JUL5R1_1 | head -n 1
zcat $JUL5R1_2 | head -n 1
zcat $JUL5R1_3 | head -n 1
zcat $JUL5R1_4 | head -n 1
cat $JUL5R1_1 $JUL5R1_2 $JUL5R1_3 $JUL5R1_4 > JUL5_R1merge.fastq.gz
JUL5R2_1=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JUL5_L001_ds.5b4c06c3d6ed406f94794ee03783ecdf/JUL5_S144_L001_R2_001.fastq.gz
JUL5R2_2=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JUL5_L002_ds.5af0dc9982d24c42be68f83088c49945/JUL5_S144_L002_R2_001.fastq.gz
JUL5R2_3=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JUL5_L003_ds.fda6283021544a9e983cc0cc70f1ca62/JUL5_S144_L003_R2_001.fastq.gz
JUL5R2_4=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JUL5_L004_ds.80e002ceff0940a0b6e009ffa486a419/JUL5_S144_L004_R2_001.fastq.gz
zcat $JUL5R2_1 | head -n 1
zcat $JUL5R2_2 | head -n 1
zcat $JUL5R2_3 | head -n 1
zcat $JUL5R2_4 | head -n 1
cat $JUL5R2_1 $JUL5R2_2 $JUL5R2_3 $JUL5R2_4 > JUL5_R2merge.fastq.gz
####IgG
JUL5IgGR1_1=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JUL5IgG_L001_ds.acb40a67d798412ab52535c88fb334dd/JUL5IgG_S145_L001_R1_001.fastq.gz
JUL5IgGR1_2=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JUL5IgG_L002_ds.14c025ba72e649c8831745d407392d07/JUL5IgG_S145_L002_R1_001.fastq.gz
JUL5IgGR1_3=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JUL5IgG_L003_ds.cd42b9fb02b44340827ae82444e41f1c/JUL5IgG_S145_L003_R1_001.fastq.gz
JUL5IgGR1_4=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JUL5IgG_L004_ds.c70ea1a9f8454de3bcb95324700eea1f/JUL5IgG_S145_L004_R1_001.fastq.gz
zcat $JUL5IgGR1_1 | head -n 1
zcat $JUL5IgGR1_2 | head -n 1
zcat $JUL5IgGR1_3 | head -n 1
zcat $JUL5IgGR1_4 | head -n 1
cat $JUL5IgGR1_1 $JUL5IgGR1_2 $JUL5IgGR1_3 $JUL5IgGR1_4 > JUL5IgG_R1merge.fastq.gz
#
JUL5IgGR2_1=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JUL5IgG_L001_ds.acb40a67d798412ab52535c88fb334dd/JUL5IgG_S145_L001_R2_001.fastq.gz
JUL5IgGR2_2=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JUL5IgG_L002_ds.14c025ba72e649c8831745d407392d07/JUL5IgG_S145_L002_R2_001.fastq.gz
JUL5IgGR2_3=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JUL5IgG_L003_ds.cd42b9fb02b44340827ae82444e41f1c/JUL5IgG_S145_L003_R2_001.fastq.gz
JUL5IgGR2_4=/home/akelling/projects/def-juniacke/akelling/project_202107/10_rawdata/111021AKellington/JUL5IgG_L004_ds.c70ea1a9f8454de3bcb95324700eea1f/JUL5IgG_S145_L004_R2_001.fastq.gz
zcat $JUL5IgGR2_1 | head -n 1
zcat $JUL5IgGR2_2 | head -n 1
zcat $JUL5IgGR2_3 | head -n 1
zcat $JUL5IgGR2_4 | head -n 1
cat $JUL5IgGR2_1 $JUL5IgGR2_2 $JUL5IgGR2_3 $JUL5IgGR2_4 > JUL5IgG_R2merge.fastq.gz
