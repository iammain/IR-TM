#!/usr/bin/perl -w
use strict;
use warnings;
use autodie;
use HTML::Strip;
use File::Slurp();

# A very special and extinct type of space is stored here ' '
my $num_args = $#ARGV +1;

if($num_args!=1){
	print 'shoulda given correct number of arguments on command line, bro';
	exit 0;	
}
# Read the file name from command line arguments
my $filename = $ARGV[0];
# pass the file data to a scalar variable
my $value = File::Slurp::slurp($filename);
#Use this very nice perl module that keeps only the text from the html
my $hs         = HTML::Strip->new();
my $clean_text	 = $hs->parse( $value );
#print the text and proffit :)

## Remove \n from the lines split by \n and \t
my @values = split('\n', $clean_text);
foreach my $val (@values) {
	my @nvalues = split('\t', $val);
	foreach my $nval (@nvalues){
		chomp($nval);
	}
	$val = "@nvalues";
	chomp($val);
}
$clean_text = "@values";

## Remove sequences of words shorter than 10 placed between '  '
my @vs = split('  ', $clean_text);
foreach my $v (@vs) {
	my @nvs = split(' ', $v);
	if (scalar @nvs < 10){
		$v = "";
	}
}
$clean_text = "@vs";

## Do some RegExes
$clean_text =~ s/[|,]+//g; # Remove some obviously useless punctuation
$clean_text =~ s/ //g; # Remove a weird space
$clean_text =~ s/©//g; # Remove a copyright symbol
$clean_text =~ s/[«»]+//g; # Remove a foreign quotation marks
$clean_text =~ s/&[a-zA-Z]*;//g; # Remove some specific structures
$clean_text =~ s/[^\x00-\x7F]+//g; # Remove all non-English symbols
#$clean_text =~ s/\s{1,}/ /g; # Remove sequential spaces

## Remove words longer than 20 chars
@vs = split(' ', $clean_text);
foreach my $v (@vs) {	
	if (length($v) > 20){
		$v = "";
	}
}
$clean_text = "@vs";

## Remove the trailing symbols from the document, if not a sentence ending with '\. '
@vs = split('\. ', $clean_text);
pop(@vs);
$clean_text = join('. ',@vs);
$clean_text = $clean_text . '.';

print($clean_text);

exit 0;
