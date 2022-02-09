#/usr/bin/perl
# This is a one-shot script to separate the clover bac ends into paired files

use strict;

my $usage = "perl $0 <input bac fasta> <output prefix> <savelist>\n";
# >HR235467.1 TP_ABa0001A03.f TP_ABa Trifolium pratense genomic clone TP_ABa0001A03 5', genomic survey sequence
# >HR235468.1 TP_ABa0001A03.r TP_ABa Trifolium pratense genomic clone TP_ABa0001A03 3', genomic survey sequence
# >HR235469.1 TP_ABa0001A04.f TP_ABa Trifolium pratense genomic clone TP_ABa0001A04 5', genomic survey sequence
# >HR235470.1 TP_ABa0001A04.r TP_ABa Trifolium pratense genomic clone TP_ABa0001A04 3', genomic survey sequence
# >HR235471.1 TP_ABa0001A05.f TP_ABa Trifolium pratense genomic clone TP_ABa0001A05 5', genomic survey sequence
# >HR235472.1 TP_ABa0001A05.r TP_ABa Trifolium pratense genomic clone TP_ABa0001A05 3', genomic survey sequence
# >HR235473.1 TP_ABa0001A06.f TP_ABa Trifolium pratense genomic clone TP_ABa0001A06 5', genomic survey sequence
# >HR235474.1 TP_ABa0001A06.r TP_ABa Trifolium pratense genomic clone TP_ABa0001A06 3', genomic survey sequence

chomp(@ARGV);
if(scalar(@ARGV) != 3){
        print $usage;
        exit();
}

my %keep;
open(my $IN, "< $ARGV[2]");
while(my $line = <$IN>){
        chomp $line;
        $keep{$line} = 1;
}
close $IN;

my $seq = '';
open(my $FOR, "> $ARGV[1].f.fasta");
open(my $REV, "> $ARGV[1].r.fasta");
open(my $IN, "< $ARGV[0]");

my $head = <$IN>;
chomp($head);
while(my $line = <$IN>){
        chomp $line;
        if($line =~ /^>/){
                my @hsegs = split(/\s+/, $head);
                my @bsegs = split(/\./, $hsegs[1]);
                if(exists($keep{$bsegs[0]})){
                        if($bsegs[1] eq "f"){
                                print {$FOR} ">$bsegs[0]\n$seq\n";
                        }else{
                                print {$REV} ">$bsegs[0]\n$seq\n";
                        }
                }
                $seq = '';
                $head = $line;
        }else{
                $seq .= $line;
        }
}
close $IN;
close $FOR;
close $REV;
