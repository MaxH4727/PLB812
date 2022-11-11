#!/bin/bash --login
#SBATCH --time=2:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=100GB
#SBATCH --job-name Lab7_BWA
##SBATCH --mail-type=ALL
##SBATCH --mail-user=harmanm4@msu.edu

#Change to current working directory
cd /mnt/home/harmanm4/PLB812/Lab7/trimmed

#Add conda environment to the path
export PATH="${HOME}/miniconda3/envs/BWA/bin:${PATH}"
export LD_LIBRARY_PATH="${HOME}/miniconda3/envs/BWA/lib:${LD_LIBRARY_PATH}"

#Build BWA Index
bwa index /mnt/home/harmanm4/PLB812/Arabidopsis_Genome/Athaliana_447_TAIR10.fa

#BWA Alignment and convert to BAM
bwa mem -t 10 /mnt/home/harmanm4/PLB812/Arabidopsis_Genome/Athaliana_447_TAIR10.fa SRR492407_1_paired_output.gq.gz SRR492407_2_paired_output.fg.gz | samtools sort -@10 -o /mnt/home/harmanm4/PLB812/Lab7/alignment/SRR492407_aligned.bam

cd ../alignment

#flagstat
samtools flagstat -@ 10 SRR492407_aligned.bam > mapping_statistics.flagstat


