## GenomeSize

Project to test/play with genome-size esetimates from kmers and correlations with other traits.

#### Plan 

##### Kmer

Kmer counting failed, as coverage was too low. Quick and dirty trials suggested it was giving reasonable estimates only for genomes >>10X coverage.

##### Genes

Here, the idea is that if we have a known quantity of DNA in each line, genome size should negatively correlate with the percent of reads mapping to that known quantity.  We start off using the cDNA.

It turns out a lot fo the cDNA are probably repetitive, as a large number of reads map to them (sometimes 2% of the genome!).  This is clearly unrealistic, and probably due to some TEs being annotated as genes and/or TEs picking up bits of exon of real genes.

Our solution is to filter the set of cDNAs to those that have a beleivable number of reads mapping, and use that as the constant amount of "known" DNA.



#### Files

* RIMMAs_list.txt: list of 51 RIMMA lines from the centromere diversity panel for which we have flow cytommetry estimates of genomes size
* hm2.files: list of the hm2 lines for which I extracted a small amount of fastq sequence for testing
* 

depths: depth data, each row is: LINE TOTAL_READS TOTAL_BP_ALIGNED MEAN_FPKM WEIGHTED_MEAN_FPKM where weighting is done on gene length

example_gene_depths: mean depth per gene for RIMMA0619 as an example

seed_size.Rmd: R markdown of NAM genome size from Chia et al. vs. phenotype data from Panzea. 
Shows plant height flowering time correlation, but not with seed size.

# Proof of concept

Zea_mays.AGPv3.20.cdna.all.fa: cdna ab initio for v3 reference genome. Probably sucky, but should catch all/most real stuff.
cdna_lengths: length of each cdna in Zea_mays.AGPv3.20.cdna.all.fa, u seful for calculating per gene depth. Same file as v21.

Zea_mays.AGPv3.21.cdna.T01.fa : cdna for v3 reference genome. only T01 for each gene, filtered out all genes except ones with cdna:known and not categorized as "abinitio".  
use: cat Zea_mays.AGPv3.22.cdna.all.fa| perl -ne '$print=0; while(<>){ if($_=~m/^>/){ if( $_=~m/T01/ && $_=~m/known/ ){ $print=1 } else{ $print=0 }; }; print $_ if $print==1}'  > Zea_mays.AGPv3.22.cdna.T01.fa
