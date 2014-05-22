#!/usr/bin/perl -w
use strict;
use warnings;
use File::Slurp;

my $file = "../irtm entities/locations.csv";

my $forGephi = "true";


my $text = read_file( $file ) ;
my $text = $text . read_file("locations.csv");
my $text = $text . read_file("organization.csv");
$text  =~ s/["\d,]//g;
my @dictionary = split("\n" ,$text);
splice(@dictionary, 0, 1);
$file='DBKnime.csv';
open(INFO, $file) or die("Could not open  file.");

my $dir = "DBKnimeSplit";
foreach my $fp (glob("$dir/*.csv")) {
#printf "%s\n", $fp;
		open my $fh, "<", $fp or die "can't read open ";
		filterRelationsOverDictionary($fp);

}



exit(0);

sub filterRelationsOverDictionary{
		my $file = shift;
		open(INFO, $file) or die("Could not open  file.");

		my $gephiFile = $file;
		my @File = split('/' ,$gephiFile);
		$gephiFile = @File[1];
		$gephiFile =~ s/\.csv//g;

		foreach my $line (<INFO>)  {
				print $line;
				for(@dictionary){
						my @nouns = split(";", $line);
						if ( index( lc @nouns[0] , lc $_) > -1){
								my @individualTokens = split("_" , @nouns[0]);
								my $matchfound = "false";
								for my $individualToken(@individualTokens){
										if ( index( lc $individualToken , lc $_) > -1){
												for my $secondRelation(@dictionary){
														my @secondIndividualToken = split("_" , @nouns[1]);
														for my $secondIndividualToken(@secondIndividualToken){
																if( index( lc $secondIndividualToken , lc $secondRelation)>-1 && length($secondIndividualToken)== length($secondRelation)){
																		if($forGephi eq "true"){
																				my $newRelation ="";
																				$newRelation = $newRelation . $_ . ';' . $gephiFile . "\n";
																				$newRelation = $newRelation.  $gephiFile. ';' . $secondRelation  ."\n";
																				open(FILEZ,  ">>DBKnimeSplit/${gephiFile}gephi.csv");
																				print FILEZ $newRelation;
																				close FILEZ;
																				$matchfound= "true";
																				last;
																		}else{
																				print $line;
																				open(my $line, '>>', "DBKnimeSplit/${gephiFile}DB.csv");
																				last
																		}
																}

														}
														if($matchfound eq "true"){
																last;
														}
												}
												if($matchfound eq "true"){
														last;
												}

										}
								}


						}elsif(index( lc @nouns[1],lc $_) > -1){
								my @individualTokens = split("_" , @nouns[1]);
								my $matchfound = "false";
								for my $individualToken(@individualTokens){
										if ( index( lc $individualToken , lc $_) > -1){
												for my $secondRelation(@dictionary){
														my @secondIndividualToken = split("_" , @nouns[0]);
														for my $secondIndividualToken(@secondIndividualToken){
																if( index( lc $secondIndividualToken , lc $secondRelation)>-1  && length($secondIndividualToken)== length($secondRelation)){
																		if($forGephi eq "true"){
																				my $newRelation ="";
																				$newRelation = $newRelation . $secondRelation . ';' . $gephiFile. "\n";
																				$newRelation = $newRelation .  $gephiFile . ';' . $_ ."\n";
																				open(FILEZ, ">>DBKnimeSplit/${gephiFile}gephi.csv");
																				print FILEZ $newRelation;
																				close FILEZ;
																				$matchfound = "true";
																				last;
																		}else{
																				open(my $line, '>>', "DBKnimeSplit/${gephiFile}DB.csv");
																				print $line;
																				last
																		}
																}
														}
														if($matchfound eq "true"){
																last;
														}
												}
												if($matchfound eq "true"){
														last;
												}

										}
								}
						}
				}
		}
		close(INFO);

}
#print $text;
