#!/bin/bash -l
#SBATCH -D /home/jri/projects/genomesize
#SBATCH -J jellyfish
#SBATCH -o outs/out-%j.txt
#SBATCH -p bigmem
#SBATCH -e errors/error-%j.txt
#SBATCH -c 2
#SBATCH -p serial
#SBATCH --array=101-200

alias JELLY="/home/jri/pkg/bin/jellyfish"

f=$( sed -n "$SLURM_ARRAY_TASK_ID"p ./data/jiao_lines )
echo "$f"
NAME=$( echo "$f" | sed -e 's/\/group\/jrigrp\/Share\/Jiao_SRA_fastq\///g')
/home/jri/pkg/bin/jellyfish count -m 20 -o temp/$NAME.counted -t 2 -C -s 100M <( zcat $f )
/home/jri/pkg/bin/jellyfish merge -o results/$NAME.merged temp/$NAME*
rm temp/$NAME*
/home/jri/pkg/bin/jellyfish histo -o results/$NAME.hist results/$NAME.merged
rm results/$NAME.merged
