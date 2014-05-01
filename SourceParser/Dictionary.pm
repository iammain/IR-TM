package Dictionary;
use strict;
use warnings;
use Exporter;


our  @ISA = qw(Exporter);
our @EXPORT = qw(fetchDictionary getExistingLinkDB); # symbols to export on request

my @dictionary 	= (	"putin", "Putin",
			"Moscow", "moscow",
			"Kiev", "kiev", "kyev", "Kyev", "Kiev's", "Kyev's", "kiev's", "kyev's",
			"Kharkiv", "Kharkov", "Lugansk", "Slovyansk", "Kramatorsk",
			"Russia", "russia", "Russian Federation", "russian federation",
			"ukraine", "Ukraine", "ukraina", "Ukraina", "Ukranian", "ukranian", "Ukrainians", "ukrainians", 
			"krimea", "crymea", "Krimea", "Crymea", "Krim", "krim", "Krym", "krym",
			"sanctions", "Sanctions", 
			"usa", "U.S.", "USA", "US", "United States",
			"EU", "European Union", "Europe",
			"obama", "Obama",
			"Maidan", "maidan",
			"Nazi", "nazi", "fashists",
			"crisis", "Crisis",
			"Cold War");

sub fetchDictionary(){
		@dictionary;
}

sub getExistingLinkDB(){
		my $file='linkDb.txt';
		open(INFO, $file) or die("Could not open  file.");
		my @existingLinks = ("foo");
		foreach my $line (<INFO>)  {   
			 push(@existingLinks, $line); 
		}
	@existingLinks;	
}



1;
