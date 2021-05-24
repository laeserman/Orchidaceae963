#!/usr/bin/perl -w

use strict;
my @infiles = glob("*.out");
my $count = $ARGV[0];

foreach my $infile (@infiles) {
# read the blast reports  and get the best hit
    my %hash;
    open IN, $infile;
    while (<IN>) {
        chomp;
        my $line = $_;
        my @field = split(/\t/,$line);
        my ($query, $identity, $evalue) = ($field[0], $field[3], $field[10]);
        #print "$query\t$hit\t$identity\t$evalue\n";
        $hash{$query}{$evalue}{$identity} = $line;
    }
    close IN;

# scroll through and get the best hit(s) for each query and print to summary file 
    open OUT, ">$infile.top";
    foreach my $query (sort keys %hash){
        my $num_hits = 0;
        foreach my $evalue (sort {$a<=>$b} keys %{$hash{$query}}) {
	    foreach my $identity (sort {$b<=>$a} keys %{$hash{$query}{$evalue}}) {
                        #print OUT "$id\t$hit\t$identity\t$evalue\n" if $num_hits < $count;        # print out only query, hit, and evalue
		print OUT "$hash{$query}{$evalue}{$identity}\n" if $num_hits < $count;   # print out entire line
		$num_hits++;
	    }
        }
    }
    close OUT;
}
