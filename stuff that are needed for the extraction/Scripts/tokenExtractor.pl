#!/usr/bin/perl -w
use strict;
use warnings;



my $file = 'finalUberFile.txt';
open my $info, $file or die "Could not open $file: $!";
my $counter = 0;
while( my $line = <$info>){
	$counter++;
	my $firstnoun    = '';
	my $secondnoun   = '';
	my $verb         = '';
	my $confidence   = '';


	if($counter<12){	
		next;
	}

	if($line >= 0.8){
		#print $counter;
		#print "Y";

		my $i = 0;
		while($i<4) {
			$line = <$info>;
			$counter++;
			$i++;
		}
		$firstnoun = $line;
		$line = <$info>;
		$verb = $line;
		$line = <$info>;
		$secondnoun = $line;
		$line = <$info>;
		
		$firstnoun =~ s/\n//g;
		$secondnoun =~ s/\n//g;
		$verb =~ s/\n//g;
		$firstnoun =~ s/[\s,]/_/g;
		$secondnoun =~ s/[\s,]/_/g;
		$verb =~ s/[\s,]/_/g;

		$firstnoun =~ s/_{2,}/_/g;
		$secondnoun =~ s/_{2,}/_/g;
		$verb =~ s/_{2,}/_/g;

#		print $firstnoun . ";" . $verb . "\n";
#		print $verb . ";". $secondnoun . "\n";

		print $firstnoun . ";" . $verb . ";". $secondnoun . "\n";

		$i = 0;
		while($i<10) {
			$line = <$info>;
			$counter++;
			$i++;
		}
	
	}
	else
	{
		#print $counter;
		#print "N";

		my $n= 0;
		while($n<17){
			$line = <$info>;
			$counter++;
			$n++;
		}
	}
	
}

close $info;




exit 0;
