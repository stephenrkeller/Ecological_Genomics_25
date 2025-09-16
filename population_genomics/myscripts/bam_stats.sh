#!/bin/bash

# If you plan to run this job on the cluster, paste the SBATCH header here and customize it


module load gcc samtools


# Add your comments/annotations here.




# Path to the population_genomics folder in your repo:

REPO=

# Directory where the mapping alignment files live:

INPUT=

# Your pop:

MYPOP=

# For each section below, I've given you a placeholder ("XXXX") 
# You'll need to replace with the correct variable at each step in your loops
# This will require you to think carefully about which vriable name shoudl go in which placeholder!  
# Think: where do you want to use input paths vs. sample (pop) names!


### Make the header for your pop's stats file

echo -e "SampleID Num_reads Num_R1 Num_R2 Num_Paired Num_MateMapped Num_Singletons Num_MateMappedDiffChr Coverage_depth" \
  >${REPO}/myresults/${MYPOP}.stats.txt


### Calculate stats on bwa alignments

for FILE in ${INPUT}/${MYPOP}*.sorted.rmdup.bam  # loop through each of your pop's processed bam files in the input directory
do
	F=${FILE/.sorted.rmdup.bam/} # isolate the sample ID name by stripping off the file extension
	NAME=`basename ${F}`  # further isolate the sample ID name by stripping off the path location at the beginning
	echo ${F} >> ${REPO}/myresults/${MYPOP}.names  # print the sample ID names to a file
	samtools flagstat ${FILE} | awk 'NR>=9&&NR<=15 {print $1}' | column -x  # calculate the mapping stats
done >> ${REPO}/myresults/${MYPOP}.flagstats  # append the stats as a new line to an output file that increases with each iteration of the loop


### Calculate mean sequencing depth of coverage

for FILE2 in ${INPUT}/${MYPOP}*.sorted.rmdup.bam
do
	samtools depth ${FILE2} | awk '{sum+=$3} END {print sum/NR}'  # calculate the per-site read depth, sum across sites, and calc the mean by dividing by the total # sites
done >> ${REPO}/myresults/${MYPOP}.coverage # append the mean depth as a new line to an output file that increases with each iteration of the loop


### Put all the stats together into 1 file:

paste ${REPO}/myresults/${MYPOP}.names \
	${REPO}/myresults/${MYPOP}.flagstats \
	${REPO}/myresults/${MYPOP}.coverage \
	>>${REPO}/myresults/${MYPOP}.stats.txt # stitch ('paste') the files together column-wise
