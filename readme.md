## GenomeSize

Project to test/play with genome-size esetimates from kmers and correlations with other traits.

#### Plan 

##### Kmer

Jellyfish kmer counting, gce to do genome size estimation. 
Correlate those with actual genome size data from Bilinski. 
If estimates of genome size match, use kmer methods in NAM RILs to look for flowering time effects.

Failed because coverage is <1 for all lines, so all kmers should map only 1. No information on genome size there.

##### Filtered Genes

Should be able to use percentage of reads mapping to FGS, assuming on average single copy, as a means of estimating genome size.

#### Files

seed_size.Rmd: R markdown of NAM genome size from Chia et al. vs. phenotype data from Panzea. 
Shows plant height flowering time correlation, but not with seed size.

Zea_mays.AGPv3.20.cdna.all.fa: cdna ab initio for v3 reference genome. Probably sucky, but should catch all/most real stuff.

