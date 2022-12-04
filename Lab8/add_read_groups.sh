#!/bin/bash --login
#SBATCH --time=2:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=100GB
#SBATCH --job-name Lab8_mark_dup
##SBATCH --mail-type=ALL
##SBATCH --mail-user=harmanm4@msu.edu

#Change to current working directory
cd /mnt/home/harmanm4/PLB812/Varient_Calling/alignment

#Add conda environment to the path
export PATH="${HOME}/miniconda3/envs/gatk/bin:${PATH}"
export LD_LIBRARY_PATH="${HOME}/miniconda3/envs/gatk/lib:${LD_LIBRARY_PATH}"

java -jar ~/miniconda3/pkgs/picard-2.27.4-hdfd78af_0/share/picard-2.27.4-0/picard.jar AddOrReplaceReadGroups I=SRR492407_aligned_marked_duplicates.bam \
O=SRR492407_dup_mark_read_add.bam \
RGID=1 \
RGLB=lib1 \
RGPL=ILLUMINA \
RGPU=NA \
RGSM=WS2

echo "done"

