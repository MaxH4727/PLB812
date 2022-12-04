#!/bin/bash --login
#SBATCH --time=10:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=100GB
#SBATCH --job-name Lab8_hap_caller
#SBATCH --mail-type=ALL
#SBATCH --mail-user=harmanm4@msu.edu

#Change to current working directory
cd /mnt/home/harmanm4/PLB812/Varient_Calling/alignment

#Add conda environment to the path
export PATH="${HOME}/miniconda3/envs/gatk/bin:${PATH}"
export LD_LIBRARY_PATH="${HOME}/miniconda3/envs/gatk/lib:${LD_LIBRARY_PATH}"


gatk HaplotypeCaller \
-R /mnt/home/harmanm4/PLB812/Arabidopsis_Genome/Athaliana_447_TAIR10.fa \
-I SRR492407_dup_mark_read_add.bam \
-O SRR492407_called_vars.vcf
