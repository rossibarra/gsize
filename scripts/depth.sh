#!/bin/bash -l
#SBATCH -D /home/jri/projects/genomesize
#SBATCH -J depths
#SBATCH -o outs/out-%j.txt
#SBATCH -p bigmem
#SBATCH --ntasks=1
#SBATCH -e errors/error-%j.txt

# script to estimate depth from sortted bam files 
FILES=/home/jri/projects/genomesize/results/*.bam

for f in $FILES;
do
	echo "$f"
	NAME=$( echo "$f" | sed -e 's/\/home\/jri\/projects\/genomesize\/results\///g')
#	echo $NAME $( samtools view -c $f ) $( bedtools genomecov -ibam $f -g /home/jri/projects/genomesize/data/cdna_length_file.txt | \
#        perl -ne 'while(<>){ chomp; @data=split(/\t/,$_);
#	$depths{$data[0]}+=$data[1]*$data[4]; $lengths{$data[0]}=$data[3]; $tbp_align+=$data[1]*$data[2]; }
#	END { print STDERR $ngenes; foreach(keys(%depths)){ $ngenes++; $fpkm+=($depths{$_}-$fpkm)/$ngenes; 
#	$weighted_fpkm+=$depths{$_}*$lengths{$_}; $total_length+=$lengths{$_};}; 
#	$weighted_fpkm=$weighted_fpkm/$total_length; print "$tbp_align\t$fpkm\t$weighted_fpkm\n"; }') >> results/depths.txt

#this version only counts genes with depth<1
       echo $NAME $( samtools view -c $f ) $( bedtools genomecov -ibam $f -g /home/jri/projects/genomesize/data/cdna_length_file.txt | \
        perl -ne 'while(<>){ chomp; @data=split(/\t/,$_);
       $depths{$data[0]}+=$data[1]*$data[4]; $lengths{$data[0]}=$data[3]; $tbp_align+=$data[1]*$data[2]; }
       END { print STDERR $ngenes; foreach(keys(%depths)){ next unless $depths{$_}<1; $ngenes++; $fpkm+=($depths{$_}-$fpkm)/$ngenes;
       $weighted_fpkm+=$depths{$_}*$lengths{$_}; $total_length+=$lengths{$_};};
       $weighted_fpkm=$weighted_fpkm/$total_length; print "$tbp_align\t$fpkm\t$weighted_fpkm\n"; }') >> results/cutdepths.txt

done

#bedtools output: gene depth bp_at_depth length_gene percent_gene_at_depth
#GRMZM2G356191_T01	0	2914	3014	0.966821
#GRMZM2G356191_T01	1	100	3014	0.0331785
#GRMZM2G054378_T01	0	3251	3499	0.929123
#GRMZM2G054378_T01	1	213	3499	0.0608745
#GRMZM2G054378_T01	2	1	3499	0.000285796
#GRMZM2G054378_T01	3	34	3499	0.00971706
#GRMZM2G054378_T03	0	1968	2068	0.951644
#GRMZM2G054378_T03	1	100	2068	0.0483559
#GRMZM2G054378_T09	0	975	1075	0.906977
#GRMZM2G054378_T09	1	100	1075	0.0930233

#e.g. GRMZM2G054378 has 3251bp with 0 depth, 213bp with depth=1 (which is 6.1% of the gene), etc.
