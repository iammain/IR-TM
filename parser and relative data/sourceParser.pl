#!/usr/bin/perl -w
use warnings;

use XML::Simple;
use Data::Dumper;
use List::MoreUtils 'any';
#description cleaner modules
use HTML::Strip;
use File::Slurp();


#random string generator
use Data::GUID qw( guid_string );

#Dictionary is a module file that has all the words that are considered relevant
#Furthermore, dictionary will update the linkDB.txt file which is a file that contains all the files that have already been added to the database
use Dictionary;


my @sources = ("cnn", "washingtonpost", "xinhua", "rt","aljazeera", "itar-tass", "reuters", "ria");

#my @sources = ("xinhua");
my $count = 0;

foreach (@sources){
		my $dire = "${_}";
		parseDirector($dire);
}
sub parseDirector{
		our $dirPostFix     = $_[0];
		our $dir 			= "~/Desktop/datastuff/${dirPostFix}";

		our @mydictionary 	= fetchDictionary();;
		our $dictionarySize  = scalar @mydictionary;
		our @existingLinks   = getExistingLinkDB();

#print $dir , "\n";
		for my $file (glob "$dir/*.txt") {
#print "${file}", "\n";
				my $xml = new XML::Simple(keyAttr=> []);
				eval{
						our $data = $xml->XMLin($file);
				};if($@){
						print $@;
						next;
				}
#different rules should probably apply to some feeds, On the TODO list
				our $arrayz =  $data->{channel}->{item};
				for my $art (@{ $data->{channel}->{item} } ){
						my $hs         = HTML::Strip->new();
						my $clean_text = $hs->parse( $art->{description});

						$clean_text =~ s/[\$#@~!&*()\[\];.,:?'^"`\\\/]+//g; # remove some characters
								$clean_text =~ s/(\b\w{1,3}\b)+//g;                 # remove 1-3 word letters

								my @split_text = split(' ' , $clean_text);
						my $alreadyPassed = "false";
						for (@split_text){	
								for ($count = 0; $count<$dictionarySize; $count++) {

#set the link to lower case, all dictionary terms are lowercase
										if(lc $_ eq lc  @mydictionary[$count]) {
												$X = lc $art->{link};
												$X =~ s/www.//g;
												$X =~ s/"//g;
												my $linkCount = 1;
												for my $links(@existingLinks){
													$links =~ s/www.//g;
													$links =~ s/"//g;


													if(lc $links eq lc $X){	
														$linkCount= 0;
													}
												}
												if( $linkCount == 1 ) {	
														my $guid = guid_string();
														my $linker = lc $art->{link};
														`wget -O datafiles/${dirPostFix}/$art->{title}.html $art->{link} | echo ${linker} >> linkDb.txt`;
														@existingLinks = getExistingLinkDB();
														$alreadyPassed = "found";
														for my $single(@existingLinks){
																$single =~ s/[\n]//g;
														}
														last;	
												}
										}
								}
								if($alreadyPassed eq "found"){
										last;
								}
						}
				}
		}
}
