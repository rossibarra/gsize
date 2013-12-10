#!/bin/bash -l
#SBATCH -D /home/jri/projects/genomesize
#SBATCH -J FGSmap
#SBATCH -o outs/out-%j.txt
#SBATCH -p serial
#SBATCH -e errors/error-%j.txt

# script to run bwa mem on paul's files

FILES=/group/jrigrp/Share/PaulB_Data/Run1_Fwd/*fastq


for f in $FILES;
do
	echo "$f"
	NAME=$( echo "$f" | sed -e 's/\/group\/jrigrp\/Share\/PaulB\_Data\/Run1\_Fwd\///g')
	/home/jri/pkg/bin/jellyfish count -m 20 -o temp/$NAME.counted -t 4 -s 10000000 $f 
	/home/jri/pkg/bin/jellyfish merge -o results/$NAME.merged temp/$NAME*
	/home/jri/pkg/bin/jellyfish histo -o results/$NAME.hist results/$NAME.merged
done

