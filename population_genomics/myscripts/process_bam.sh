#!/bin/bash

# If you plan to run on the cluster, paste your SBATCH head here and customize it


#---------  End Slurm preamble, job commands now follow

# Remove all software modules and load all and only those needed

module purge


# Below here, give you bash script with your list of commands



module load gcc sambamba 

### Processing the alignment files

### Add your comments/annotations here

INPUT="/gpfs1/cl/ecogen/pbio6800/PopulationGenomics/bams"  # path where the *sam alignments live

MYPOP="2030_57_O"  # your 4-digit pop code

cd $INPUT

### Convert sam to bam and sort by alignment coordinates
for FILE in ${MYPOP}*.sam

do
	NAME=${FILE/.sam/}
	sambamba view -S -t 10 --format=bam ${FILE} -o ${NAME}.bam
	sambamba sort -t 10 --tmpdir=/users/s/r/srkeller/scratch ${NAME}.bam -o ${NAME}.sorted.bam
done


### Removing PCR duplicates
for FILE2 in ${MYPOP}*.sorted.bam

do
	NAME2=${FILE2/.sorted.bam/}
	sambamba markdup -r -t 10 ${FILE2} ${NAME2}.sorted.rmdup.bam
done


### Indexing for fast lookup

for FILE3 in ${MYPOP}*.sorted.rmdup.bam
	
do
	sambamba -t 10 index ${FILE3}
done

