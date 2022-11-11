sra_list="SRR492407"

for sra in ${sra_list}
do
        #Prefetch will download the SRA file into a directory of the same name.
        #We will move the file out into our current working directory and remove
        #the empty directory
        mv ${sra}/*sra ./
        rmdir ${sra}

        #Use fastq-dump to convert the SRA format to a gzipped fastq format
        fastq-dump --gzip --split-3 ${sra}.sra
done

echo "done"
