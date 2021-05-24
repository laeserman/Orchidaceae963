#!/usr/bin/perl
use strict;
use Cwd;
#Lauren Eserman

#This script takes the contigs output from spades and blasts against the reference
#to identify exons matching each contig
#Before running this script, run makeblastdb on the reference file

my $reference = $ARGV[0];
my $wd = getcwd;


my @files = glob("*.fasta");
foreach my $file (@files) {
#    open OUT, ">$file.blast.sh";
    system "blastn -query $file -db $reference -out $file.out -evalue 1E-20 -outfmt 6 -num_threads 4";
#    system "qsub $file.blast.sh";
}
