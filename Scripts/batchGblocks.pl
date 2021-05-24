#!/usr/bin/perl -w
use strict;
use Cwd;
#Karolina Heyduk - heyduk@uga.edu - 2014

my $wd = getcwd;

my @files = glob("*.best.fas"); #assumes you ran prank as described in batchAlign.pl - if not, make sure to change this so it matches the end of your filenames
foreach my $file (@files) {
    my $count = 0;
    open IN, "<$file";
    while (<IN>) {
	chomp;
	my $line = $_;
	if ($line =~ ">") {
	    $count++;
	    #print "$count";
	}
	else {
	    next;
	}
    }
    my $half = int(($count/2)+1); #calculating half of the alignment columns for filtering - modify as you'd like here or below by replacing $half with an actual numerical value.
#    open OUT, ">$file.gb.sh";
#    print OUT "#PBS -N $file\n#PBS -l nodes=2:ppn=4\n#PBS -l pmem=2gb\n#PBS -l walltime=150:00:00\n#PBS -q force-6\n#PBS -j oe\n#PBS -o $file.out\n#PBS -m abe\n\ncd $wd\n\n/nv/hp16/leserman3/data/Gblocks_0.91b/Gblocks $file -t=d -b1=$half -b2=$half -b3=25 -b4=10 -b5=a -e gb";
#    close OUT;
#    system "msub $file.gb.sh";
    system "/storage/home/hcoda1/5/leserman3/p-ecoffey30-0/rich_project_pf1/Gblocks_0.91b/Gblocks $file -t=d -b1=$half -b2=$half -b3=25 -b4=10 -b5=a -e gb";
    print "$file\n\n";
}

