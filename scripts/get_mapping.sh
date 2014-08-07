#!/bin/bash -l
#SBATCH -D /home/jri/projects/genomesize
#SBATCH -J readcounts
#SBATCH -o outs/out-%j.txt
#SBATCH -p bigmem
#SBATCH --ntasks=1
#SBATCH -e errors/error-%j.txt
#SBATCH --array=1-51

module load bwa/0.7.5a

#FILE=$( sed -n "$SLURM_ARRAY_TASK_ID"p data/hm2.files ).bam
FILE=$( sed -n "$SLURM_ARRAY_TASK_ID"p data/RIMMAs_list.txt )

echo $FILE
#gets total reads and mapped reads from bamfile
#samtools view alignments/$FILE | tee >( cut -f 1 | sort -n | uniq | wc -l >results/$FILE.total ) | cut -f 1,3 | grep -v "*" | cut -f 1 | sort -n | uniq | wc -l > results/$FILE.mapped;
perl scripts/parsesam.pl <( samtools view alignments/$FILE | sort -n -k 1 ) results/abundance."$FILE".txt
