#!/bin/bash --login
#SBATCH --time=8:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=12
#SBATCH --mem=100GB
#SBATCH --job-name Total_SRA_Import_fastqc
#SBATCH --mail-type=ALL
#SBATCH --mail-user=harmanm4@msu.edu

#Change to current working directory
cd /mnt/home/harmanm4/PLB812/At_RNAseq

#Add conda environment to the path
export PATH="${HOME}/miniconda3/envs/PLB812/bin:${PATH}"
export LD_LIBRARY_PATH="${HOME}/miniconda3/envs/PLB812/lib:${LD_LIBRARY_PATH}"

bio_list="SAMEA3245902 SAMEA3245900 SAMEA3245899 SAMEA3245898 SAMEA3245923 SAMEA3245914"

for bio in ${bio_list}
do
	#Use prefetch from the SRA toolkit to get the SRA file
	prefetch ${bio}
	#Prefetch will download the SRA file into a directory of the same name.
done

sra_list="ERR*"

for sra in ${sra_list}
do
        #We will move the file out into our current working directory and remove
        #the empty directory
        mv ${sra}/*sra ./
        rmdir ${sra}

        #Use fastq-dump to convert the SRA format to a gzipped fastq format
        fastq-dump --gzip --split-3 ${sra}.sra
	
	#move .sra files to seperate directory
	mv ${sra}.sra /SRAs
done

fastqc -t 12 -o /mnt/home/harmanm4/PLB812/At_RNAseq/qc ERR*

echo "done"

