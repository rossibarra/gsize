#!/bin/bash -l
#SBATCH -D /home/jri/projects/genomesize
#SBATCH -J FGSmap
#SBATCH -o outs/out-%j.txt
#SBATCH -p bigmem
#SBATCH --ntasks=2
#SBATCH -e errors/error-%j.txt
#SBATCH --array=1-103

module load bwa/0.7.5a

#for hapmap2

	# Be sure to add array jobs to header here.
	#SBATCH --array=1-103

	FILE=$( sed -n "$SLURM_ARRAY_TASK_ID"p data/hm2.files )
	bwa mem -t 2 /home/jri/projects/genomesize/data/Zea_mays.AGPv3.22.cdna.T01.fa data/hm2/"$FILE".1 | samtools view -Su - > alignments/$FILE.bam

#for Paul's RIMMA files
	#FILES=/group/jrigrp/Share/PaulB_Data/Run1_Fwd/*fastq

	#for f in $FILES;
	#do
	#NAME=$( echo "$f" | sed -e 's/\/group\/jrigrp\/Share\/PaulB\_Data\/Run1\_Fwd\///g')
	#bwa mem -t 2 ../data/Zea_mays.AGPv3.20.cdna.all.fa /group/jrigrp/Share/PaulB_Data/Run1_Fwd/$NAME | samtools view -Su > ../alignments/$NAME.bam
	#done
