#!/bin/bash -l
#SBATCH -D /home/jri/projects/genomesize
#SBATCH -J getFGS
#SBATCH -o outs/out-%j.txt
#SBATCH -p bigmem
#SBATCH --ntasks=4
#SBATCH -e errors/error-%j.txt

for i in $( ls /group/jrigrp3/hapmap2_bam/Disk3CSHL_bams_bwamem/*merged*bam ); do
out=$( echo $i | sed -e 's/.*\///g' | sed -e 's/bam/fq/g')
bedtools bamtofastq -i <( samtools view -s 0.02 -u $i ) -fq data/hm2/$out
done

