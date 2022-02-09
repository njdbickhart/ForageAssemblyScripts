#!/usr/bin/bash
# This script is designed to filter and align BAC end sequences to a reference genome
# Requirements: must have minimap2 and the perl interpreter installed on your PATH. Also, must have https://github.com/njdbickhart/perl_toolchain/blob/master/bed_cnv_fig_table_pipeline/nameListVennCount.pl on your PATH
# Output: a brief table listing the number of BAC ends that map to the same or different scaffolds.

# $1 = input BAC end fasta (forward)
# $2 = input BAC end fasta (reverse)
# $3 = input reference assembly
# $4 = output prefix

# establish list of BAC names
grep '>' $1 > for.list
grep '>' $2 > rev.list

name1=`echo $1 | cut -d'.' -f1`
name2=`echo $2 | cut -d'.' -f1`

nameListVennCount.pl -l 1_2 for.list rev.list | perl -lane 'if($F[0] =~ /File/){next;}else{$F[0] =~ s/>//; print "$F[0]";}' > shared.list

# create filtered list of BACs for alignment
perl generate_pairs.pl $1 ${name1}.for shared.list
perl generate_pairs.pl $2 ${name2}.rev shared.list

# Map and generate output
minimap2 -ax sr $3 ${name1}.for.fasta ${name2}.rev.fasta > $4.sam
perl -lane 'if($F[0] =~ /^@/){next;} if($F[1] & 2048){}else{print $_;}' < $4.sam | tabFileColumnCounter.py -f stdin -c 6 -i '@' -d '\t' | perl -e '%h; <>; while(<>){chomp; @s = split(/\t/); if($s[0] eq "="){$h{"same"} += $s[1];}elsif($s[0] eq "*"){$h{"unmap"} += $s[1];}else{$h{"different"} += $s[1];}} foreach $i ("same", "different", "unmap"){print "$i\t$h{$i}\n";}' > $4.final.tab