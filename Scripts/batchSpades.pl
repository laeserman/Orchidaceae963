#!/usr/bin/perl
use strict;
use Cwd;
use Data::Dumper;
#Lauren Eserman

my $dir = $ARGV[0]; #FULL PATH to spades folder, include final "/"
my $reads = $ARGV[1]; #FULL PATH to clean reads directory, include final "/"
my $list = $ARGV[2]; #list of libIDs, should be the prefix of trimmomatic outputs
my @files = glob("*fastq"); #push files with correct ending into an array
my $wd = getcwd;

#read library index file, store in hash
my @libIDs;
open IN, "<$list";
while (<IN>) {
    chomp;
    push (@libIDs, $_);
}
close IN;
print "@libIDs\n";

#make spades folders and submission scripts
for my $libID (@libIDs) {       
    system "mkdir $dir/spades$libID"; 
    chdir("$dir/spades$libID");
    open OUT, ">$libID.spades.sh"; #make a shell file for spades submission
    print OUT "#PBS -N $libID\n#PBS -l nodes=2:ppn=4\n#PBS -l pmem=2gb\n#PBS -l walltime=150:00:00\n#PBS -q force-6\n#PBS -j oe\n#PBS -o $libID.out\n#PBS -m abe\n\ncd $dir\n\nmodule load python\n\npython /nv/hp16/leserman3/data/SPAdes-3.13.0-Linux/bin/spades.py -1 $reads/$libID\_paired\_R1.fastq -2 $reads/$libID\_paired\_R2.fastq -o $dir/spades$libID";
    system "msub $libID.spades.sh";
    chdir("$wd");
    close OUT;
}
