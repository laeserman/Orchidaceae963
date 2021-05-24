#!/usr/bin/perl
use strict;
use warnings;
use Bio::SeqIO;

my @infiles = glob("*targets.fasta");
foreach my $infile (@infiles) {
    my %sequences;
    my @dups;
    my $io_obj = Bio::SeqIO->new(-file => "$infile", -format => "fasta" );
    while (my $seq_obj = $io_obj->next_seq) {
	my $id = $seq_obj->id;
	my $seq = $seq_obj->seq;    
	if (defined ($sequences{$id})) {
	    push (@dups, $id);      
        }
	else {
	    $sequences{$id} = $seq;
	}
    }

    open OUT, ">$infile.norep";
    open OUT2, ">$infile.reps" or die $!;
    my $io_obj1 = Bio::SeqIO->new(-file => "$infile", -format => "fasta" );
#my $counter = 1;
    while (my $seq_obj1 = $io_obj1->next_seq) {
        my $id1 = $seq_obj1->id;
        my $seq1 = $seq_obj1->seq;
        if ($id1 ~~ @dups) {
	    print OUT2 ">$id1\n$seq1\n";
        }
        else {
	    print OUT ">$id1\n$seq1\n";
        }
    }       
    close OUT;
    close OUT2; 

}
