# Sam2Xpkm
Calculate RPKM and FPKM from SAM file

RNA-Seq provides quantitative approximations of the abundance of target transcripts in the form of counts. However, these counts must be normalized to remove technical biases inherent in the preparation steps for RNA-Seq, in particular the length of the RNA species and the sequencing depth of a sample. For example, expectedly, deeper sequencing results in higher counts, biasing comparisons between different runs with different depths. Similarly, longer transcripts are more likely to have sequences mapped to their region resulting in higher counts, biasing comparisons between transcripts different lengths.


Both `RPKM` and `FPKM` provide the means for such normalization.

```
RPKM = reads per kilobase per million
     = [# of mapped reads]/[length of transcript in kilo base]/[million mapped reads]
     = [# of mapped reads]/([length of transcript]/1000)/([total reads]/10^6)
FPKM = fragments per kilobase per million
     = [# of fragments]/[length of transcript in kilo base]/[million mapped reads]
     = [# of fragments]/([length of transcript]/1000)/([total reads]/10^6)
```

FPKM is essentially analogous to RPKM but, rather than using read counts, approximates the relative abundance of transcripts in terms of fragments observed from an RNA-Seq experiment, which may not be represented by a single read, such as in paired-end RNA-Seq experiments.

## Usage

`perl sam2xpkm.pl -sam sample.sam -gff sample.gff >output.csv`


## Output

STDERR output
```
Total Reads:		198
Pair unmapped Reads:		
Single unmapped Reads:		11
Single mapped Reads:		11
Pair mapped Reads:		176
Mapped fragments:		11
```


output.csv
```
start	end	mapped_reads	mapped_fragments	RPKM	FPKM
10	104	79	10	4.19989367357788e-09	5.31632110579479e-10
114	281	101	1	3.03631553631554e-09	3.00625300625301e-11
````
