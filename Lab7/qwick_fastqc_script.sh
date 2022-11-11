#!/bin/bash --login
#SBATCH --time=2:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=100GB
#SBATCH --job-name Lab7_qc_trim_qc
##SBATCH --mail-type=ALL
##SBATCH --mail-user=harmanm4@msu.edu

#Change to current working directory
cd /mnt/home/harmanm4/PLB812/Lab7/trimmed

#Add conda environment to the path
export PATH="${HOME}/miniconda3/envs/PLB812/bin:${PATH}"
export LD_LIBRARY_PATH="${HOME}/miniconda3/envs/PLB812/lib:${LD_LIBRARY_PATH}"

Lab7_list="SRR492407_1 SRR492407_2"

bio=SRR492407

fastqc -t 2 ${bio}_1_paired_output.gq.gz
fastqc -t 2 ${bio}_2_paired_output.fg.gz
