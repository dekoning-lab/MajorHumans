#This program converts an input vcf using the old reference genome (hg19) to a
#vcf relative to a selected alternative reference. The input vcf header is left
#as is as well as anything in the info fields of the input vcf. Note, this may
#cause some statistics such as allele frequencies to become incorrect.

#Author: John Hall, de Koning Lab http://lab.jasondk.io

use strict;
use warnings;

#Grab the command line arguments, the first is the reference used for 
#converting, the second is the input vcf to convert
my $newRef = shift;
my $input = shift;

#Open the two input files
open (NEWREF, $newRef) or die "Could not open reference file: $newRef\n";
open (INPUT, $input) or die "Could not open input file: $input\n";

#Skip through the file header on the reference genome
my $newRefLine = <NEWREF>;
while ($newRefLine =~ /^#/) {
    $newRefLine = <NEWREF>;
}

#Define some variables to store information about the vcf lines
my $inputMatch;
my $inputChrom;
my $inputPos;
my $inputRef;
my $inputAlt;
my $newRefMatch;
my $newRefChrom;
my $newRefPos;
my $newRefRef;
my $newRefAlt;

#Loop to convert each line of the input file relative to the input reference
for my $inputLine (<INPUT>) {
    #Print out the file header of the input vcf unchanged
    if ($inputLine =~ /^#/) {
	print "$inputLine";
    } else {
	#Regular expression to grab pieces of the input vcf to convert
	$inputMatch = $inputLine =~ /([0-9]+|X|Y)\t([0-9]+)\t.*?\t([ACTG]+)\t([ACTG,]+)\t.*/;
	#Encode chromosome as a number for comparison
	if ($1 eq "X") {
	    $inputChrom = 23;
	} elsif ($1 eq "Y") {
	    $inputChrom = 24;
	} else {
	    $inputChrom = $1;
	}
	$inputPos = $2;
	$inputRef = $3;
	$inputAlt = $4;
	#Regular expression to grab pieces of the reference to convert to
	$newRefMatch = $newRefLine =~ /([0-9]+|X|Y)\t([0-9]+)\t.*?\t([ACTG]+)\t([ACTG,]+)\t.*/;
	#Encode chromosome as a number for comparison
	if ($1 eq "X") {
	    $newRefChrom = 23;
	} elsif ($1 eq "Y") {
	    $newRefChrom = 24;
	} else {
	    $newRefChrom = $1;
	}
	$newRefPos = $2;
	$newRefRef = $3;
	$newRefAlt = $4;
	
	#Process each line of the input vcf
	my $lineProcessed = 0;
	while ($lineProcessed == 0) {
	    if ($inputChrom == $newRefChrom) {
		if ($inputPos == $newRefPos) {
		    if ($inputAlt ne $newRefAlt) {
			#chromosome and position of the reference match the
			#input line but the alternate allele has changed.
			#Print out the line but change the reference allele.
			$inputMatch = $inputLine =~ s/([0-9]+|X|Y)\t([0-9]+)\t(.*?)\t([ACTG]+)\t([ACTG,]+)\t(.*)/$1\t$2\t$3\t$newRefAlt\t$5\t$6/;
			print "$inputMatch";
			$lineProcessed = 1;
		    } else {
			#The lines are identical, do not print anything
			$lineProcessed = 1;
		    }
		} elsif ($inputPos < $newRefPos) {
		    #The new reference does not contain this allele, print the
		    #line as is.
		    print "$inputLine";
		    $lineProcessed = 1;
		} else {
		    #The reference may still contain this allele, grab the next
		    #line.
		    $newRefLine = <NEWREF>;
		    if (!(defined $newRefLine)) {
			#if there are no more reference lines, we are done.
			last;
		    }
		    #Pull the information from the new reference line we just
		    #grabbed
		    $newRefMatch = $newRefLine =~ /([0-9]+|X|Y)\t([0-9]+)\t.*?\t([ACTG]+)\t([ACTG,]+)\t.*/;
		    if ($1 eq "X") {
			$newRefChrom = 23;
		    } elsif ($1 eq "Y") {
			$newRefChrom = 24;
		    } else {
			$newRefChrom = $1;
		    }
		    $newRefPos = $2;
		    $newRefRef = $3;
		    $newRefAlt = $4;
		}
	    } elsif ($inputChrom < $newRefChrom) {
		#Reference has crossed a chromosome boundry.
		#Input file line is not in the reference, print it.
		print "$inputLine";
		$lineProcessed = 1;
	    } else {
		#The reference may still contain this allele, grab the next
		#line.
		$newRefLine = <NEWREF>;
		if (!(defined $newRefLine)) {
		    last;
		}
		$newRefMatch = $newRefLine =~ /([0-9]+|X|Y)\t([0-9]+)\t.*?\t([ACTG]+)\t([ACTG,]+)\t.*/;
		if ($1 eq "X") {
		    $newRefChrom = 23;
		} elsif ($1 eq "Y") {
		    $newRefChrom = 24;
		} else {
		    $newRefChrom = $1;
		}
		$newRefPos = $2;
		$newRefRef = $3;
		$newRefAlt = $4;
	    }
	}
	#Print any lines remaining in the input file after we have gone through
	#the entire reference file.
	print "$inputLine";
    }
}
