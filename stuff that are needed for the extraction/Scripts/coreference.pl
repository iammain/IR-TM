#!/usr/bin/perl -w
use strict;
use warnings;
use HTML::Strip;
use File::Slurp;
use XML::Simple;
use XML::Smart;
use Data::Dumper;
use XML::Mini::Document;
use Scalar::MoreUtils qw(empty);
use Encode;
my $dir = "~/Desktop/parsedData";
my $datadir = "~/Desktop/alldata";
my $dataCount = 0;
my $currentfile;
eval{
		foreach my $fp (glob("$datadir/*")) {
#
#	Modify the file name so that the txt and xm files can be parsed
#				
				$currentfile = $fp;
				print "\n" . $fp . "\n";
				my $tmpCor = $fp;
				$tmpCor =~ s/\/home\/panos\/Desktop\/alldata\///g;

#
#	Read the XML using XML::Simple
#
				my $fileUri  = "/home/panos/Desktop/parsedData/" . $tmpCor . ".xml";
				open (XML, $fileUri) or die $!;
				undef($/);
				my $xml = <XML>;
				close XML;
				$/ = "\n";

				my $test_data = read_file( $fileUri );
				
				my $xml_doc = XML::Mini::Document->new();
				$xml_doc->parse($test_data);
				$test_data = $xml_doc->toHash();
				my $corefRules = $test_data->{root}->{document}->{coreference};
#
#	Split the sentenes using Lingua::Sentence
#
#	save all the elements where a new sentence happens
				my @sentencesPoints;
				my @sentences;
				my $text = read_file( $fp );
				$text =~ s/\n//g;

				my @tokenPositions;
				my $sentenceId = 0;

				my @sentenceElements;
				my $sentenceElementId =0;
				for(@{$test_data->{root}->{document}->{sentences}->{sentence}}){
						my $tempTxt = $_->{parse};
						my @data = $tempTxt =~ /[\w.`\\',\.\/\*\(\&^%\$!@#:;"]+\)/g;
						for my $temp(@data){
								$temp =~ s/\)//g;
						}
						@sentenceElements[$sentenceElementId] = [@data];
						$sentenceElementId++;
				}
				my $sentenceIdz = 0;
				for my $singleSentence((@sentenceElements)){
						my $tempSentence = '';
						for(@{$singleSentence}){
								if( $tempSentence eq ''){
										$tempSentence = $tempSentence . $_;
								}
								else{
										my $lastTempChar = substr($tempSentence,length($tempSentence)-1,1);
										my $firstNewChar = substr($_ , 0 ,1);
										if ( $lastTempChar =~ m/\w/ ) {
												if($firstNewChar =~ m/\w/){
														$tempSentence = $tempSentence . ' ' . $_;	
												}else{
														$tempSentence = $tempSentence . $_;
												}
										}else{
												if($firstNewChar =~ m/\w/){
														$tempSentence = $tempSentence ." " . $_;						
												}else{
														$tempSentence = $tempSentence . $_;
												}	
										}
								}
						}
						$tempSentence =~ s/^``\s/``/g;
						push @sentences, $tempSentence;
						$sentenceIdz++;
				}
				for(@{$test_data->{root}->{document}->{sentences}->{sentence}}){
						push(@sentencesPoints,$_->{tokens}->{token}->[0]->{CharacterOffsetBegin});
						my @sentenceTokens;
						for my $toks(@{$_->{tokens}->{token}}){
								push(@sentenceTokens , $toks->{CharacterOffsetBegin});
						}
						$tokenPositions[$sentenceId]= [@sentenceTokens];
						$sentenceId++;
				}	
				my @sentenceTokenEnd;

#
#	Fix the coreferences
#	
				my $currentBase;
				for my $documentCoreferences($corefRules->{coreference}){
						for my $mentionsGroup ( @{ $documentCoreferences} ){
								for my $singleMention (@{$mentionsGroup->{mention}}){
										if (exists $singleMention->{representative}) {
												$currentBase = $singleMention->{text};
												$currentBase =~ s/\s/_/g;
										} else {
												my $string  = @sentences[$singleMention->{sentence}-1];
												my $stuff = $string;

												my @sentenceTokens = $tokenPositions[$singleMention->{sentence}-1];	
												my $offset = $sentenceTokens[0][$singleMention->{start}-1] - $sentenceTokens[0][0];
# Find an offset that is not within a word if the offset is corrupt										
												#print $stuff;
												#print $offset;
												#print "\n";
												if( $offset> length($stuff)){
													$offset = length($stuff)-1;
												}
												else{
													while( substr($stuff, $offset ,1) ne ' '
																	&& substr($stuff, $offset ,1) ne "\n"
																	&& substr($stuff, $offset ,1) ne "."
																	&& substr($stuff, $offset ,1) ne ""){
															$offset++;
															if($offset>1000){
																	last;
															}
													}
												}

												substr($stuff, $offset,0 ) = ",". $currentBase . ",";
# increase the offsets of the elements after the current Base insertion . The plus to is for the curly bracers
												for($tokenPositions[$singleMention->{sentence}-1]){
														for my $i ( $singleMention->{start} ... scalar(@{$_})-1 ){
																$tokenPositions[$singleMention->{sentence}-1][$i]  =  $tokenPositions[$singleMention->{sentence}-1][$i] + length($currentBase)+2;
														}
												}

												#print $stuff ."\n";
												@sentences[$singleMention->{sentence}-1] = $stuff;
										}
								}
						}
						print "\n\n\n\n ------------new file same folder---------------- \n\n\n\n ";

						for(@sentences){
							print "${_}  ";
						}
						unlink $fp;
				}
		}
}or do{
		my $e = $@;
		print("Something Went Wrong, probably no coreferneces error of i${e}!!");
		unlink $currentfile;
		`perl coreference.pl >>  aggregatedData.txt`;
};




exit 0;
