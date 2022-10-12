#!/bin/bash --login
#SBATCH --time=5:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=6
#SBATCH --mem=100GB
#SBATCH --job-name alignment_hisat2
#SBATCH --mail-type=ALL
#SBATCH --mail-user=harmanm4@msu.edu
#SBATCH --output=%x-%j.SLURMout
#Change to current working directory
cd /mnt/home/harmanm4/PLB812/At_RNAseq/trimmed_fastq/paired_reads

#Add conda environment to the path
export PATH="${HOME}/miniconda3/envs/PLB812/bin:${PATH}"
export LD_LIBRARY_PATH="${HOME}/miniconda3/envs/PLB812/lib:${LD_LIBRARY_PATH}"

HISAT2_INDEXES=/mnt/home/harmanm4/PLB812/Arabidopsis_Genome/Index

sra_list="ERR754054 ERR754062 ERR754067 ERR754079 ERR754080 ERR754088"

for sra in ${sra_list}
do
        #Hisat2 command
	hisat2 -p 6 -x /mnt/home/harmanm4/PLB812/Arabidopsis_Genome/Index/At_RNA_REF_INDEX -1 ${sra}_1_paired_output -2 ${sra}_2_paired_output | samtools view -bh | samtools sort > ${sra}_aligned.bam

done

echo "done"
