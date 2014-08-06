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


##### Results dir
* seed_size.Rmd: R markdown analysis of genome size correlation and some phenotypes using hapmap2 data. Shows plant height flowering time correlation, but not with seed size.


##### Other dirs

* errors/outs: You will need an "outs" and an "errors" directory to run these scripts on the cluster, but these are not included in the git as we don't need to track zillions of logfiles.
* data/hm2: this directory is referenced in scripts and is where I store the subsampled fastq from HM2. See "gethm2.sh" script for details. Not included in repo.
* alignments: where bam alignments are stored. not included in repo
* parsesam.pl: Paul's script for splitting sam output into reads per gene, counting multiplt mapping reads as fractions. **Currently does not work correctly for paired end reads**


### Analysis

#### Clean up cDNA

We start by removing all the ab initio genes and only keeping the first transcript. Unzip the cDNA and run:

	perl -e 'open FILE, "<Zea_mays.AGPv3.22.cdna.all.fa"; while(<FILE>){ if($_=~m/^>/ ){ $_=~m/^>GRMZ.*_T(\d+)/; $transcript=$1; $known= $_=~m/known/ ? 1:0; $abinit=$_=~m/abinitio/ ? 1: 0; }; if($transcript == "01" && $known == 1 && $abinit==0){ print $_; }} '  > Zea_mays.AGPv3.22.cdna.T01.fa

Then we index the file:

	bwa index Zea_mays.AGPv3.22.cdna.T01.fa




## Ignore from here below, needs to be cleaned up

depths: depth data, each row is: LINE TOTAL_READS TOTAL_BP_ALIGNED MEAN_FPKM WEIGHTED_MEAN_FPKM where weighting is done on gene length

example_gene_depths: mean depth per gene for RIMMA0619 as an example

should catch all/most real stuff.
cdna_lengths: length of each cdna in Zea_mays.AGPv3.20.cdna.all.fa, u seful for calculating per gene depth. Same file as v21.

