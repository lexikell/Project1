# Project1
Make gene alignment pipline from your own data and own scripts
to use in Compute Canada

#PLAN
- your script drafts can go in this project and you can move/run them in computecanada
- Once tested on your own, you could even test on SRA db
    https://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?view=toolkit_doc

#PIPLINE OUTLINES
Mine: 
- QC: FASTQC (prologue. Files not used in downstream)
- align: BWA
- BAM format: samtools
- peak calling: MACS2 (broadpeak)
    https://github.com/macs3-project/MACS
- remove Blacklist w/ Bedtools
- ChipPeakAnno (Bioconductor)
    uses the broadpeak (blacklist removed) 
    The "quick guide" compared broadpeak data with the encode hg38 genome and output a list which I saved as a csv file
        (contains genes names & can be further manipulated)

Gorini 2020
- QC: NGS-QC Toolkit
- Alignments: BWA
    - to hg18
- Filtering & file format conversions: SAMtools and bedtools
- Peaks idenified: MACS
    - from uniquely mapped reads without duplicates
    - P< 1e-5 and fold enrichment >7
    - DNA input control
- Data visualization: UCSC Genome Browser
- Normalized uniquely mapped reads: BamCompare tool in Deeptools suite
    - unique reads normalized over input 
    - log2 OG/input ratio
    - SES method as scaling factor
    - fixes any GC sequencing bias or DNA amount differences
- Metagene analysis: computeMatrix in Deeptools
- Heatmaps: plot Heatmap tools in Deeptools
- Signal profile plots: R 
    - from the matrices from computeMatrix