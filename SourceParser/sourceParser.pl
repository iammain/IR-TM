#!/usr/bin/perl -w
use warnings;

use XML::Simple;
use Data::Dumper;

#random string generator
use Data::GUID qw( guid_string );

#Dictionary is a module file that has all the words that are considered relevant
#Furthermore, dictionary will update the linkDB.txt file which is a file that contains all the files that have already been added to the database
use Dictionary;


my @sources = ("aljazeera", "itar-tass", "reuters", "ria",  "cnn", "washingtonpost", "xinhua", "rt");


my $count = 0;

foreach (@sources){
		my $dire = "${_}";
		parseDirector($dire);
}

sub parseDirector{
		our $dirPostFix     = $_[0];
		our $dir 			= "../Data/${dirPostFix}";
		our @mydictionary 	= fetchDictionary();;
		our $dictionarySize  = scalar @mydictionary;
		our $existingLinks   = getExistingLinkDB();
		print $dir , "\n";
		for my $file (glob "$dir/*.txt") {
				my $xml = new XML::Simple(keyAttr=> []);
				my $data = $xml->XMLin($file);

				#different rules should probably apply to some feeds, On the TODO list

				my $arrayz =  $data->{channel}->{item};

				for my $art (@{ $data->{channel}->{item} } ){
						for ($count = 0; $count<$dictionarySize; $count++) {
								#set the link to lower case, all dictionary terms are lowercase
								if(index(lc $art->{link}, $mydictionary[$count])>=0) {
										$X = $art->{link};
										if( grep(/^$X$/,@existingLinks) ==0 ){
												my $guid = guid_string();

												`wget -O ../Data/${dirPostFix}/${guid}.html $art->{link} | echo $art->{link} >> linkDb.txt`;
												@existingLinks = getExistingLinkDB();
										}
								}
						}
				}
		}
}
