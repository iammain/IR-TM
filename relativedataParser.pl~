#!usr/bin/perl -w

#use warnings;
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
		`perl IRTM_HTML_cleaner.pl $dirfiles/$_[0]/$file >> $dirclean/$_[0]/$file`;
		my $string = "\"".$file."\",\"".`perl IRTM_HTML_cleaner.pl $dirfiles/$_[0]/$file`."\"\n";
		 
		my $filename = "${dirclean}/${_[0]}/docs.csv";
		open(my $fh, '>>', $filename) or die "Could not open file '$filename' $!";
		print $fh "${string}";
		close $fh;
	}
}
