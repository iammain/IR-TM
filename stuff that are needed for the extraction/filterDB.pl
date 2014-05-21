#!/usr/bin/perl -w
use strict;
use warnings;
use File::Slurp;

my $file = "persons.csv";

my $forGephi = "true";


my $text = read_file( $file ) ;

$text  =~ s/["\d,]//g;
my @dictionary = split("\n" ,$text);
splice(@dictionary, 0, 1);
$file='DBKnime.csv';
open(INFO, $file) or die("Could not open  file.");
my $counter = 0;
foreach my $line (<INFO>)  {
		$counter++;
		for(@dictionary){
				my @nouns = split(";", $line);
				if ( index( lc @nouns[0] , lc $_) > -1){
						my @individualTokens = split("_" , @nouns[0]);
						my $matchfound = "false";
						for my $individualToken(@individualTokens){
								if ( index( lc $individualToken , lc $_) > -1){
										for my $secondRelation(@dictionary){
												my @secondIndividualToken = split("_" , @nouns[2]);
												for my $secondIndividualToken(@secondIndividualToken){
														if( index( lc $secondIndividualToken , lc $secondRelation)>-1){
																if($forGephi eq "true"){
																		my $newRelation ="";
																		$newRelation = $newRelation . $_ . ';' . @nouns[1] . "\n";
																		$newRelation = $newRelation.  @nouns[1] . ';' . $secondRelation  ."\n";
																		print $newRelation;
																		$matchfound = "true";
																		last;
																}else{
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


				}elsif(index( lc @nouns[2],lc $_) > -1){
						my @individualTokens = split("_" , @nouns[2]);
						my $matchfound = "false";
						for my $individualToken(@individualTokens){
								if ( index( lc $individualToken , lc $_) > -1){
										for my $secondRelation(@dictionary){
												my @secondIndividualToken = split("_" , @nouns[0]);
												for my $secondIndividualToken(@secondIndividualToken){
														if( index( lc $secondIndividualToken , lc $secondRelation)>-1){
																if($forGephi eq "true"){
																		my $newRelation ="";
																		$newRelation = $newRelation . $secondRelation . ';' . @nouns[1] . "\n";
																		$newRelation = $newRelation .  @nouns[1] . ';' . $_ ."\n";
																		print $newRelation;
																		$matchfound = "true";
																		last;
																}else{
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
		if($counter>15000){
				last;
		}
}
close(INFO);


#print $text;
