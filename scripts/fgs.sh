#!/bin/bash -l
#SBATCH -D /home/jri/projects/genomesize
#SBATCH -J FGSmap
#SBATCH -o outs/out-%j.txt
#SBATCH -p bigmem
#SBATCH --ntasks=2
#SBATCH -e errors/error-%j.txt

# script to run bwa mem on paul's files
module load bwa/0.7.5a
FILES=/group/jrigrp/Share/PaulB_Data/Run1_Fwd/*fastq

for f in $FILES;
do
	echo "$f"
	NAME=$( echo "$f" | sed -e 's/\/group\/jrigrp\/Share\/PaulB\_Data\/Run1\_Fwd\///g')
	bwa mem -t 2 /home/jri/projects/genomesize/data/Zea_mays.AGPv3.21.cdna.T01.fa $f | samtools view -Su - | samtools sort - results/$NAME 
#	bwa mem -t 2 ../data/Zea_mays.AGPv3.20.cdna.all.fa /group/jrigrp/Share/PaulB_Data/Run1_Fwd/$NAME | samtools view -S -b > ../results/$NAME.bam
done
