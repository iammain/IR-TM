package Dictionary;
use strict;
use warnings;
use Exporter;


our  @ISA = qw(Exporter);
our @EXPORT = qw(fetchDictionary getExistingLinkDB); # symbols to export on request

my @dictionary = ("putin","ukraine","krimea","war","usa","obama","military","stuff");

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
