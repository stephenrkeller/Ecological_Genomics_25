#!/bin/bash

# Paste the following header below the first line of your bash script 
# (i.e., after the line: #!/bin/bash)



#---------  Slurm preamble, defines the job with #SBATCH statements

# Give your job a name that's meaningful to you, but keep it short
#SBATCH --job-name=reads2bams

# Name the output file: the first part of the name (%x) will be whatever you name your job 
#SBATCH --output=~/courses/Ecological_Genomcis_25/population_genomics/mylogs/%x_%j.out

# Which partition to use: options include short (<3 hrs), general (<48 hrs), or week
#SBATCH --partition=general

# Specify when Slurm should send you e-mail.  You may choose from
# BEGIN, END, FAIL to receive mail, or NONE to skip mail entirely.
#SBATCH --mail-type=ALL
#SBATCH --mail-user=srkeller@uvm.edu

# Run on a single node with four cpus/cores and 8 GB memory
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=64G

# Time limit is expressed as days-hrs:min:sec; this is for 24 hours.
#SBATCH --time=24:00:00

#---------  End Slurm preamble, job commands now follow

# Below here, give you bash script with your list of commands

bash mapping.sh

bash process_bam.sh

bash bam_stats.sh




