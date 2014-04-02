#!/bin/bash -l
#SBATCH -D /home/jri/projects/genomesize
#SBATCH -J jellyfish
#SBATCH -o outs/out-%j.txt
#SBATCH -p bigmem
#SBATCH -e errors/error-%j.txt
#SBATCH -c 4
#SBATCH -p bigmem
#SBATCH --array=1-10

alias JELLY="/home/jri/pkg/bin/jellyfish"
module load bamtools

#f=$( sed -n "$SLURM_ARRAY_TASK_ID"p ./data/jiao_lines )
f=$( sed -n "$SLURM_ARRAY_TASK_ID"p ./data/bigmerged.txt )
echo "$f"
#NAME=$( echo "$f" | sed -e 's/\/group\/jrigrp\/Share\/Jiao_SRA_fastq\///g')
NAME=$( echo "$f" | sed -e 's/\/group\/jrigrp\/hapmap2_bam\/Disk3CSHL_bams_bwamem\///g')
#/home/jri/pkg/bin/jellyfish count -m 20 -o temp/$NAME.counted -t 2 -C -s 100M <( zcat $f )
/home/jri/pkg/bin/jellyfish count -m 30 -o temp/$NAME.counted -t 4 -C -s 500M <( bamtools convert -in $f -format fastq )
/home/jri/pkg/bin/jellyfish merge -o results/$NAME.merged temp/$NAME*
rm temp/$NAME*
/home/jri/pkg/bin/jellyfish histo -h 100000 -o results/$NAME.hist results/$NAME.merged
rm results/$NAME.merged
