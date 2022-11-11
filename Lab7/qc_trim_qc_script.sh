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
cd /mnt/home/harmanm4/PLB812/Lab7

#Add conda environment to the path
export PATH="${HOME}/miniconda3/envs/PLB812/bin:${PATH}"
export LD_LIBRARY_PATH="${HOME}/miniconda3/envs/PLB812/lib:${LD_LIBRARY_PATH}"

Lab7_list="SRR492407_1 SRR492407_2"

#initial qc
for bio in ${Lab7_list}
do
fastqc -t 2 ${bio}.fastq.gz
done

fastq=SRR492407

#Tmmomattic script with arguments
#        trimmomatic PE -phred33 -threads 2 \
 #       ${fastq}_1.fastq.gz ${fastq}_2.fastq.gz \
  #      ${fastq}_1_paired_output.gq.gz ${fastq}_1_unpaired_output.fg.gz \
   #     ${fastq}_2_paired_output.fg.gz ${fastq}_2_unpaired_output.fg.gz \
    #    ILLUMINACLIP:/mnt/home/harmanm4/miniconda3/envs/PLB812/share/trimmomatic-0.39-2/adapters/TruSeq2-PE.fa:2:30:10:2:True \
     #   LEADING:25 TRAILING:25 MINLEN:36

#post-trim qc
for bio in ${Lab7_list}
do
fastqc -t 2 ${bio}_paired_output.fq.gz
fastqc -t 2 ${bio}_unpaired_output.fq.gz
done

echo "done"


