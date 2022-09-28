#!/bin/bash --login
#SBATCH --time=2:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=3
#SBATCH --mem=100GB
#SBATCH --job-name Fastqc_Assignment
#SBATCH --output=%x-%j.SLURMout
#SBATCH --mail-type=ALL
#SBATCH --mail-user=harmanm4@msu.edu

#Change to current working directory
cd $/mnt/home/harmanm4/PLB812

#Add conda environment to the path
export PATH="${HOME}/miniconda3/envs/PLB812/bin:${PATH}"
export LD_LIBRARY_PATH="${HOME}/miniconda3/envs/PLB812/lib:${LD_LIBRARY_PATH}"

fastqc [-o ./Lab2] [-t 3] Athaliana_447_Araport11.transcript.fa.gz  Athaliana_447_TAIR10.fa.gz  ERR754088_1.fastq

