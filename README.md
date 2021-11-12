# ForageAssemblyScripts
---

This is a collection of helpful assembly scripts and utilities for use in assembling the genomes of plant forage species.

## Version 0.0.1

This repository currently consists of two Perl scripts that provide general utility for the assembly of Eukaryotic species genomes. Both scripts supply usage statements and require only a base installation of Perl v5.8+. Here is a brief summary of the usage statements:

#### alignAndOrderSnpProbes.pl

```bash
perl ./perl_scripts/alignAndOrderSnpProbes.pl

Input:
-a <Assembly fasta file> AND -p <Probe fasta file>
OR
-n <Nucmer alignment format>
OR
-g <Blast alignment format> AND -m <alignment length to filter (int)>

Optional:
-c <circos flag>
AND
-f <query fasta samtools fai file>
AND
-r <reference fasta samtools fai file>

Output:
-o <Base name for all output files>
```

#### filterOverhangAlignments.pl

```bash
perl ./perl_scripts/filterOverhangAlignments.pl <input overhang PAF file> <the original full PAF file> <output file name>
```
