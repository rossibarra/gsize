#!/bin/bash -l
#SBATCH -D /home/jri/projects/genomesize
#SBATCH -J getFGS
#SBATCH -o outs/out-%j.txt
#SBATCH -p bigmem
#SBATCH -e errors/error-%j.txt
#SBATCH --array=1-103

module load bwa/0.7.5a

FILE=$( sed -n "$SLURM_ARRAY_TASK_ID"p data/hm2.files | sed -e 's/fq/bam/' )

out=$( echo $FILE | sed -e 's/.*\///g' | sed -e 's/bam/fq/')
bedtools bamtofastq -i <( samtools view -s 0.05 -u $FILE ) -fq data/hm2/$out.1 -fq2 data/hm2/$out.2

