#!/bin/bash --login
#SBATCH --time=2:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=100GB
#SBATCH --job-name Fastqc_Assignment
##SBATCH --mail-type=ALL
##SBATCH --mail-user=harmanm4@msu.edu

#Change to current working directory
cd /mnt/home/harmanm4/PLB812/At_RNAseq

#Add conda environment to the path
export PATH="${HOME}/miniconda3/envs/PLB812/bin:${PATH}"
export LD_LIBRARY_PATH="${HOME}/miniconda3/envs/PLB812/lib:${LD_LIBRARY_PATH}"

fastqc -t 4 -o qc ERR754088_2.fastq.gz ERR754080_1.fastq.gz ERR754062_1.fastq.gz ERR754062_2.fastq.gz

echo "done"
