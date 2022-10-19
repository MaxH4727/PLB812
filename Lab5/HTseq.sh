#!/bin/bash --login
#SBATCH --time=5:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=6
#SBATCH --mem=100GB
#SBATCH --job-name Read_Count_HTseq
#SBATCH --mail-type=ALL
#SBATCH --mail-user=harmanm4@msu.edu
#SBATCH --output=%x-%j.SLURMout
#Change to current working directory
cd /mnt/home/harmanm4/PLB812/At_RNAseq/alinged_bams

#Add conda environment to the path
export PATH="${HOME}/miniconda3/envs/PLB812/bin:${PATH}"
export LD_LIBRARY_PATH="${HOME}/miniconda3/envs/PLB812/lib:${LD_LIBRARY_PATH}"

sra_list="ERR754054 ERR754062 ERR754067 ERR754079 ERR754080 ERR754088"

for sra in ${sra_list}
do
        #HTseq command
        python -m HTSeq.scripts.count -f bam -s yes -n 6 -c ${sra}_htseq_output.tsv ${sra}_aligned.bam /mnt/home/harmanm4/PLB812/Arabidopsis_Genome/Athaliana_447_Araport11.gene_exons.gtf

done

echo "done"
