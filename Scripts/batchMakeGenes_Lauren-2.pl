#!/usr/bin/perl
use strict;
use warnings;
#ltr_sc003324.1_g00001.1.1
my @infiles = glob("peq_targets_filtered.fa");

foreach my $infile (@infiles) {
    my $divider = ".";
    my $position = index($infile, $divider);
    my $libid = substr($infile, 0, $position);
    open OUT, ">>$libid.genes";
    open IN, "<$infile";

    my ($gene, $exon);
    my %seqs;

    while(<IN>){
	chomp;
	if(/>/){
	    my $divider = ".";
	    my $pos = rindex($_, $divider);
	    $gene = substr($_, 0, $pos);
	    $exon = substr($_, $pos+1);
	    #print "$gene\t$exon\n";
	}
	else{
	    $seqs{$gene}{$exon}=$_;
	}
    }
    foreach my $gene (sort keys %seqs){
        my $seq;
	for my $exon (sort {$a<=>$b} keys %{$seqs{$gene}}){
	    $seq.=$seqs{$gene}{$exon};
	}
	print OUT "$gene\_$libid\n$seq\n";
    }
    close OUT;
    close IN;
}
