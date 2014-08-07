## GenomeSize

Project to test/play with genome-size estimates from kmers and correlations with other traits.

### Plan

Kmer counting failed, as coverage was too low. Quick and dirty trials suggested it was giving reasonable estimates only for genomes >>10X coverage.


Here, the idea is that if we have a known quantity of DNA in each line, genome size should negatively correlate with the percent of reads mapping to that known quantity.  We start off using the cDNA.

It turns out a lot fo the cDNA are probably repetitive, as a large number of reads map to them (sometimes 2% of the genome!).  This is clearly unrealistic, and probably due to some TEs being annotated as genes and/or TEs picking up bits of exon of real genes.

Our solution is to filter the set of cDNAs to those that have a beleivable number of reads mapping, and use that as the constant amount of "known" DNA.



### Files

##### Data dir

* RIMMAs_list.txt: list of 51 RIMMA lines from the centromere diversity panel for which we have flow cytommetry estimates of genomes size
* hm2.files: list of the hm2 lines for which I extracted a small amount of fastq sequence for testing
* gsize_rimma.csv: csv file of the genome sizes from flow cytometry of the RIMMAs
* Zea_mays.AGPv3.22.cdna.all.fa.gz: initial cDNA file to be used

##### Scripts dir

* gethm2.sh: script to subsample some fastq from the hapmap2 bamfiles
* jelly.sh: (don't use) script to run jellyfish kmer counter
* depth.sh: ignore for now
* fgs.sh: this maps to the cDNA reference using bwa, write to a bam file in the alignments dir. currently all commented out, needs to be run differently for HM2 and Paul's files
* get_mapping.sh: takes aligned bam files and runs 1) Paul's perl script (doesn't work for paired end reads) and a simple read counter using wc -l

##### Results dir
* seed_size.Rmd: R markdown analysis of genome size correlation and some phenotypes using hapmap2 data. Shows plant height flowering time correlation, but not with seed size.
* fixed_genes_precent.txt: output of % mapping for the "good" set of standard genes.  columns are line,total_reads,mapped_reads_corrected,percent_corrected where "corrected" means we're ignoring those genes that had too many reads hit
* mapped_uncorrected_rimma.txt: total number of reads and reads mapped to v3.22 cDNA, uncorrected for genes with too many reads mapping. from get_mapping.sh
* example.abundance.txt: example abundance per gene output from Paul's parsesam.pl script

##### Other dirs

* errors/outs: You will need an "outs" and an "errors" directory to run these scripts on the cluster, but these are not included in the git as we don't need to track zillions of logfiles.
* data/hm2: this directory is referenced in scripts and is where I store the subsampled fastq from HM2. See "gethm2.sh" script for details. Not included in repo.
* alignments: where bam alignments are stored. not included in repo
* parsesam.pl: Paul's script for splitting sam output into reads per gene, counting multiplt mapping reads as fractions. **Currently does not work correctly for paired end reads**


### Analysis

You can see results of R analyses [here](http://rpubs.com/rossibarra/24500) and [here](http://rpubs.com/rossibarra/24404).

#### Clean up cDNA

We start by removing all the ab initio genes and only keeping the first transcript. Unzip the cDNA and run:

	perl -e 'open FILE, "<Zea_mays.AGPv3.22.cdna.all.fa"; while(<FILE>){ if($_=~m/^>/ ){ $_=~m/^>GRMZ.*_T(\d+)/; $transcript=$1; $known= $_=~m/known/ ? 1:0; $abinit=$_=~m/abinitio/ ? 1: 0; }; if($transcript == "01" && $known == 1 && $abinit==0){ print $_; }} '  > Zea_mays.AGPv3.22.cdna.T01.fa
	
Note that this step is probably not necessary given the "finding good genes" steps below.

#### Map

Then we index the file:

	bwa index Zea_mays.AGPv3.22.cdna.T01.fa

Then we make sure fgs file is tweaked appropriately for our samples/dirs, and align:

	sbatch -p bigmem fgs.sh

Then we get mapping data (this uses Paul's script and assumes single end reads). May need to tweak headers and list of files names for this script to get it to run appropriately too.

	sbatch -p bigmem get_mapping.sh

#### Find set of "good" genes


Now we have a list of files names "abundance.blah" that have per-gene counts of reads mapping. We want to use these to filter out genes that have way too many reads mapping and should be removed from our "standard".

First we run through each file, get the total number of reads. Run back through each file and calculate the % of reads mapping to each genes.  We flag any gene that has more than 0.00001% of reads mapping.  We do this across all files, make a list of genes to ignore, and write that to "skip_genes.txt" in the results directory.

	cut -f 1 <( for i in $( ls abundance*); do  perl -e '@file=<>; $sum=0; print $file[0]; foreach(@file){ ($gene,$reads)=split(/,/,$_); $sum+=$reads unless $gene=~m/\*/} print $sum; foreach(@file){ ($gene,$reads)=split(/,/,$_); next if $gene=~m/\*/; print "$gene\t",$reads/$sum,"\n" if $reads/$sum>5E-5; }  ' < $i; done ) | sort -n | uniq > skip_genes.txt	
Using the skip_genes.txt file, we run back through each abundance file, and ignore genes that should be skipped, recalculating the reads mapping to our "good" reference, and writing that to a file.

	for i in $( ls abundance*); do  echo "$i,$( perl -e 'open BAD, "<skip_genes.txt"; while(<BAD>){ chomp; $badgenes{$_}=1;}; close BAD; @file=<>; $sum=0; $bigsum=0; foreach(@file){ ($gene,$reads)=split(/,/,$_); $bigsum+=$reads; next if $gene=~m/\*/; next if $badgenes{$gene}; $sum+=$reads; } print "$bigsum,$sum,",$sum/$bigsum,"\n";' < $i )" ; done > fixed_genes_percent.txt



## Ignore from here below, needs to be cleaned up



##### find which genes are high copy number badness from set of abundance files



#### gets corrected percent


depths: depth data, each row is: LINE TOTAL_READS TOTAL_BP_ALIGNED MEAN_FPKM WEIGHTED_MEAN_FPKM where weighting is done on gene length

example_gene_depths: mean depth per gene for RIMMA0619 as an example

should catch all/most real stuff.
cdna_lengths: length of each cdna in Zea_mays.AGPv3.20.cdna.all.fa, u seful for calculating per gene depth. Same file as v21.

