#!usr/bin/perl -w

use warnings;
use HTML::Strip;
use File::Slurp();





my @sources = ("cnn", "washingtonpost", "xinhua", "rt","aljazeera", "itar-tass", "reuters", "ria");


foreach (@sources){
		my $dire = "${_}";
		parseDirector($dire);
}
sub parseDirector{
		our $dirPostFix     = $_[0];
		our $dir 			= "~/Desktop/datacleanfiles/${dirPostFix}";
		for my $file (glob "$dir/*.txt") {
		 `perl -O datafiles/${dirPostFix}/$art->{title}.html $art->{link} | echo ${linker} >> linkDb.txt`;	

		}



}