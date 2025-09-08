# Markdown notebook for PopGen module -- instructor's repo

## Fall 2025

### Pipeline:

**01_fastq_trimming_QC.Rmd**

This file brings in the raw, paired end reads and calls a bash script to run the `fastp` program to trim the reads and output QC in html format.

Outputs are stored in `population_genomics/myresults/fastp_reports`

Relevant options include: trim bases \<Q20, drop reads \<35 bp
