##Major-allele reference genomes for *Homo sapiens*
####John Hall and Jason de Koning
#####April 2015

de Koning Lab, University of Calgary <BR>
and Bachelor of Health Sciences Bioinformatics Program  <BR>
http://lab.jasondk.io  <BR>

Prior to publication please cite: **Hall J and APJ de Koning (2015). MajorHumans: Major-allele reference genomes and exomes for Homo sapiens. University of Calgary. http://lab.jasondk.io**

---

###README.txt

This folder contains the initial v0.1 beta-release of *MajorHumans* haploid reference genome/exome sequences. The data are encoded as VCF files relative to the `hg19` assembly. In these reconstructions, variations such as CNVs are ignored  so that position numbers refer to assembly positions on the `hg19` assembly. This release also contains a script to re-encode an `hg19` VCF relative to one of the new reference sequences. In most cases, this should reduce the file size between 33% and 100%. This script is called `NewRefConverter.pl`

   Usage: `perl NewRefConverter.pl <newRef>.vcf <vcfToConvert>.vcf`

We include reconstructed major allele reference genomes based on several data sources including the [1000 Genomes Project](http://www.1000genomes.org) (whole genome, phase 3 release), the [NHLBI 6500 Exomes](http://evs.gs.washington.edu/EVS/) dataset, and the initial release of the [Exome Aggregation Consortium's (ExAC)](http://exac.broadinstitute.org) 65K Exomes.

The 1000 Genomes references are named `1000GPOPMajorAllele.vcf`, where POP is the 1000 Genomes population that the reference is for. The 6500 exomes references are named `6500EPOPMajorAllele.vcf` where POP is the 6500 exomes population thatthe reference is for. The 65K exomes references are named `65KPOPMajorAllele.vcf` where POP is the 65K exomes population that the reference is for. All of the new references are stored in relation to hg19.

In this release, we also include a preliminary attempt at reconstructing ancestral human and hominin reference genome sequences. These were reconstructed using the [30x Neanderthal and Denisovan genomes](http://www.eva.mpg.de/neandertal/index.html) together with 1000 Genomes data. Reconstructions were made via a pseudo-phylogenetic analysis and maximum likelihood ancestral reconstruction with RaxML. **These should best be considered as 'weighted average' sequences**; they should perform well as reference sequences. They are called `humanAncestral.vcf` and `homininAncestral.vcf` respectively.

**Note:** Info fields in the reference genome VCF files reflect the *original* data source's annotations and have not been recomputed based on the new reference genome.

---

Please report any errors or suggestions with this initial release to [Jason](mailto:jason.dekoning@ucalgary.ca).
