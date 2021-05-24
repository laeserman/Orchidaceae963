#!/usr/bin/perl
use strict;
#Karolina Heyduk - heyduk@uga.edu - 2014

#run in directory where reads are located

my $adapters = $ARGV[0]; #file with adapter sequences you wish to trim, one per line
my $list = $ARGV[1]; #read to ID index file, see manual for example
my %read1;
my %read2;
my @libIDs;

#read library index file, store R1 and R2 in hashes
open IN, "<$list";
while (<IN>) {
    chomp;
    my ($libID, $readID) = split /\t/;
    if ($readID =~ 'R1') { 
	$read1{$libID} = $readID;
	print "$libID\t$readID\n";
	if ($libID ~~ @libIDs) {
	    next;
	}
	else {
	    push(@libIDs, $libID);
	}
    }
    elsif ($readID =~ 'R2') {
	$read2{$libID} = $readID;
	print "$libID\t$readID\n";
    }
}
close IN;

for my $libID (@libIDs) {   
    open OUT, ">$libID.trim.sh";
    
    #change path to trimmomatic for your usage. Alter phred score (64 or 33) as needed.
    print OUT "#PBS -N trimmomatic \n#PBS -l nodes=2:ppn=4 \n#PBS -l pmem=2gb\n#PBS -l walltime=15:00:00\n#PBS -q force-6\n#PBS -j oe\n#PBS -o myjob.out\n#PBS -m abe\n\n\ncd /nv/hp16/leserman3/scratch/orchid_bait_set/raw_reads\n\njava -jar /nv/hp16/leserman3/data/Trimmomatic-0.38/trimmomatic-0.38.jar PE -threads 4 -phred33 $read1{$libID} $read2{$libID} $libID\_paired\_R1.fastq $libID\_unpaired\_R1.fastq $libID\_paired\_R2.fastq $libID\_unpaired\_R2.fastq ILLUMINACLIP:$adapters:2:30:10 LEADING:10 TRAILING:10 MINLEN:40";
    
    #change the submission line below to meet your system's needs. If threading is not available, remove the -th flag above.
    system "msub $libID.trim.sh"
    }
