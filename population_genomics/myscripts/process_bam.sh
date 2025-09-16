#!/bin/bash

# If you plan to run on the cluster, paste your SBATCH head here and customize it



module load gcc sambamba samtools 

### Processing the alignment files

### Add your comments/annotations here

INPUT=/gpfs1/cl/ecogen/pbio6800/PopulationGenomics/bams  # path where the *sam alignments live

MYPOP=2505  # your 4-digit pop code

cd $INPUT

### Convert sam to bam and sort by alignment coordinates
for FILE in ${MYPOP}*.sam

do
	NAME=${FILE/.sam/}
	sambamba view -S --format=bam ${FILE} -o ${NAME}.bam
	samtools sort ${NAME}.bam -o ${NAME}.sorted.bam
done


### Removing PCR duplicates
for FILE2 in ${MYPOP}*.sorted.bam

do
	NAME2=${FILE2/.sorted.bam/}
	sambamba markdup -r -t 1 ${FILE2} ${NAME2}.sorted.rmdup.bam
done


### Indexing for fast lookup

for FILE3 in ${MYPOP}*.sorted.rmdup.bam
	
do
	samtools index ${FILE3}
done

