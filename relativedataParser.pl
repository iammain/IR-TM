#!usr/bin/perl -w

#use warnings;
use HTML::Strip;
use File::Slurp();
use File::Slurp;

#my @sources = ("cnn", "washingtonpost", "xinhua", "rt","aljazeera", "itar-tass", "reuters", "ria");
my @sources = ("rt");
our $dirfiles = "datafiles";
our $dirclean = "dataclean";

foreach (@sources){
	my @files = read_dir "datafiles/${_}";
	print ${_} . "\n \n";
	parseDirector(${_},\@files);
}
sub parseDirector{
	foreach $file (@{$_[1]}){
		print $file;
		`perl IRTM_HTML_cleaner.pl $dirfiles/$_[0]/$file >> $dirclean/$_[0]/$file`;

		my @filedata = split('____', $file);

		my $title  = @filedata[0];
		my $date   = @filedata[1];


		my $source = @filedata[2];
		$source =~ s/.htm[l]+//g;


		my $string = "\"".$title."\",\"".$date."\",\"".$source."\",\"".`perl IRTM_HTML_cleaner.pl $dirfiles/$_[0]/$file`."\"\n";
		 
		my $filename = "${dirclean}/${_[0]}/docs.csv";
		open(my $fh, '>>', $filename) or die "Could not open file '$filename' $!";
		print $fh "${string}";
		close $fh;
	}
}
