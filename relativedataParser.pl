#!usr/bin/perl -w

use warnings;
use HTML::Strip;
use File::Slurp();
use File::Slurp;

my @sources = ("cnn", "washingtonpost", "xinhua", "rt","aljazeera", "itar-tass", "reuters", "ria");
our $dirfiles = "datafiles";
our $dirclean = "dataclean";

foreach (@sources){
	my @files = read_dir "datafiles/${_}";
	parseDirector(${_},\@files);
}
sub parseDirector{
	foreach $file (@{$_[1]}){
#		my $name = fileparse($file);
		`perl IRTM_HTML_cleaner.pl $dirfiles/$_[0]/$file >> $dirclean/$_[0]/$file`;
	}
}
