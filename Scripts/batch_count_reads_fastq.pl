#!/usr/bin/perl

use strict;
use warnings;

while (my $file = glob("*.fastq")) {
    system "awk '{s++}END{print s/4}' $file > $file.rdnum";
    print "$file \n";
}
