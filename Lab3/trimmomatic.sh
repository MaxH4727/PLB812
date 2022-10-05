#!/bin/bash --login
#SBATCH --time=1:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=100GB
#SBATCH --job-name trimmomatic
#SBATCH --mail-type=ALL
#SBATCH --mail-user=harmanm4@msu.edu
#SBATCH --output=%x-%j.SLURMout
#Change to current working directory
cd /mnt/home/harmanm4/PLB812/At_RNAseq/fastq

#Add conda environment to the path
export PATH="${HOME}/miniconda3/envs/PLB812/bin:${PATH}"
export LD_LIBRARY_PATH="${HOME}/miniconda3/envs/PLB812/lib:${LD_LIBRARY_PATH}"

fastq_list="ERR754054 ERR754062 ERR754067 ERR754079 ERR754080 ERR754088"

for fastq in ${fastq_list}
do
        #Trimmomattic script with arguments
        java -jar /opt/software/Trimmomatic/0.36-Java-1.8.0_92/trimmomatic-0.36.jar PE -threads 6 ${fastq}_1.fastq.gz ${fastq}_2.fastq.gz ${fastq}_1_paired_output ${fastq}_1_unpaired_output ${fastq}_2_paired_output ${fastq}_2_unpaired_output ILLUMINACLIP:/mnt/home/harmanm4/miniconda3/envs/PLB812/share/trimmomatic-0.39-2/adapters/TruSeq2-PE.fa SLIDINGWINDOW:4:15 MINLEN:36

done

fastqc -t 6  -o /mnt/home/harmanm4/PLB812/At_RNAseq/fastq/trimmed_qc ERR*output

echo "done"
