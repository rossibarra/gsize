
#gets total reads and mapped reads from bamfile
for i in $( ls -lth *.bam | grep "M Aug" | sed -e 's/.*\s//g' | sed '1d' ); do echo $i; samtools view $i | tee >( cut -f 1 | sort -n | uniq | wc -l ) | cut -f 1,3 | grep -v "*" | cut -f 1 | sort -n | uniq | wc -l; done
