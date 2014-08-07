#!/bin/bash -l
#SBATCH -D /home/jri/projects/genomesize
#SBATCH -J getFGS
#SBATCH -o outs/out-%j.txt
#SBATCH -p bigmem
#SBATCH -e errors/error-%j.txt
#SBATCH --array=1-103

module load bwa/0.7.5a

fq=$( sed -n "$SLURM_ARRAY_TASK_ID"p data/hm2.files )
bam=$( echo $fq | sed -e 's/fq/bam/' )
bamdir="/group/jrigrp3/hapmap2_bam/Disk3CSHL_bams_bwamem/"

bedtools bamtofastq -i <( samtools view -s 0.05 -u "$bamdir"/"$bam" ) -fq data/hm2/$fq.1 -fq2 data/hm2/$fq.2

