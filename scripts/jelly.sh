#!/bin/zsh -l
#SBATCH -D /home/jri/projects/genomesize
#SBATCH -J jellyfish
#SBATCH -o outs/out-%j.txt
#SBATCH -p serial
#SBATCH -e errors/error-%j.txt

# script to run jellyfish on paul's files

NAME="RIMMA0430.1"
alias JELLY="/home/jri/pkg/bin/jellyfish"

JELLY count -m 20 -o temp/$NAME.counted -t 4 -s 10000000 /group/jrigrp/Share/PaulB_Data/Run1_Rev/$NAME.fastq 
JELLY merge -o results/$NAME.merged temp/$NAME*
JELLY histo -o results/$NAME.hist results/$NAME.merged


