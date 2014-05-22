#!/usr/bin/perl -w
use strict;
use warnings;
use File::Slurp;

my $file = "../Entities\ Dictionary/persons.csv";

my $forGephi = "true";
my $text = read_file( $file ) ;
$text = $text .  read_file("../Entities\ Dictionary/organization.csv");
$text = $text . read_file("../Entities\ Dictionary/locations.csv");

$text  =~ s/["\d,]//g;
my @dictionary = split("\n" ,$text);


splice(@dictionary, 0, 1);

my $filepath = "../DBKnime.csv"; 
filterRelationsOverDictionary($filepath);
exit(0);
my $dir = "../DBKnimeSplitByRelation";
foreach my $fp (glob("$dir/*.csv")) {
#printf "%s\n", $fp;
		open my $fh, "<", $fp or die "can't read open ";
		print $fp;
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
				for(@dictionary){
						my @nouns = split(";", $line);
						if ( index( lc @nouns[0] , lc $_) > -1){
								my @individualTokens = split("_" , @nouns[0]);
								my $matchfound = "false";

								for my $individualToken(@individualTokens){
										if (( index( lc $individualToken , lc $_) > -1 || checkIfMatchesFullString($_, @nouns[0]))  && length($individualToken)== length($_)){
												for my $secondRelation(@dictionary){
														my @secondIndividualToken = split("_" , @nouns[2]);	
														for my $secondIndividualToken(@secondIndividualToken){
																if( (index( lc $secondIndividualToken , lc $secondRelation)>-1|| checkIfMatchesFullString($secondRelation, @nouns[2]) )&& length($secondIndividualToken)== length($secondRelation)){
																		if($forGephi eq "true"){
																				my $newRelation ="";
																				$newRelation = $newRelation . $_ . ';' . @nouns[1] ."\n";
																				$newRelation = $newRelation . @nouns[1] . ';' .$secondRelation . "\n";
																				#open(FILEZ,  ">>../DBKnimeSplitInGephiFormat/${gephiFile}.csv");
																				#print $gephiFile . "\n";
																				#print FILEZ $newRelation;
																				print $newRelation;
																				close FILEZ;
																				$matchfound= "true";
																				last;
																		}else{
																				print $line;
																				open(my $line, '>>', "DBKnimeSplitInGephiFormat/${gephiFile}DB.csv");
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
										if ( (index( lc $individualToken , lc $_) > -1 || checkIfMatchesFullString($_, @nouns[2]) )&& length($individualToken)== length($_)){
												for my $secondRelation(@dictionary){
														my @secondIndividualToken = split("_" , @nouns[0]);
														for my $secondIndividualToken(@secondIndividualToken){
																if( (index( lc $secondIndividualToken , lc $secondRelation)>-1 || checkIfMatchesFullString($secondRelation, @nouns[0]) ) && length($secondIndividualToken)== length($secondRelation)){
																		if($forGephi eq "true"){
																				my $newRelation = $secondRelation .';' . @nouns[1] ."\n";
																				$newRelation = $newRelation. @nouns[1] . ";" . $_ . "\n";
																				#open(FILEZ, ">>../DBKnimeSplitInGephiFormat/${gephiFile}.csv");
																				#print FILEZ $newRelation;
																				#print $gephiFile . "\n";
 																				print $newRelation;
																				close FILEZ;
																				$matchfound = "true";
																				last;
																		}else{
																				open(my $line, '>>', "DBKnimeSplitInGephiFormat/${gephiFile}DB.csv");
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


sub checkIfMatchesFullString{
	my $dictionaryTerm   = shift;
	my $stringToBeTested = shift;
	
	my @dictionArray = split(" ", $dictionaryTerm);
	if(scalar(@dictionArray)==1){
		return 0;
	}else{
		$stringToBeTested =~ s/_/\s/g;
		if(index(lc $stringToBeTested , lc $dictionaryTerm)) { 
		    return 1;
		}else{
			return 0;
		}
	}

	return 0;
}



#print $text;
