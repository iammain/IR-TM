#!/usr/bin/perl -w
use warnings;
use autodie;
use HTML::Strip;
use File::Slurp();

my @rssLinks = ("http://www.xinhuanet.com/english/rss/worldrss.xml",
                "http://rt.com/rss/",
				"http://rss.cnn.com/rss/edition.rss",
				"http://feeds.washingtonpost.com/rss/rss_blogpost",
				"http://feeds.reuters.com/Reuters/worldNews",
				"http://en.ria.ru/export/rss2/world/index.xml",
				"http://en.itar-tass.com/rss/v2.xml",
				"http://www.aljazeera.com/Services/Rss/?PostingId=2007731105943979989");

$date = localtime(time);
$date =~ s/\s/-/g;

for ($count = 0; $count <= 7; $count++) {
	if($count==0){
	 	system("wget ${rssLinks[$count]} -O ~/Desktop/datastuff/xinhua/${date}.txt");	
	}
	if($count==1){
	 	system("wget ${rssLinks[$count]} -O ~/Desktop/datastuff/rt/${date}.txt");	
	}
	if($count==2){
	 	system("wget ${rssLinks[$count]} -O ~/Desktop/datastuff/cnn/${date}.txt");	
	}
	if($count==3){
	 	system("wget ${rssLinks[$count]} -O ~/Desktop/datastuff/washingtonpost/${date}.txt");	
	}
	if($count==4){
	 	system("wget ${rssLinks[$count]} -O ~/Desktop/datastuff/reuters/${date}.txt");	
	}
	if($count==5){
	 	system("wget ${rssLinks[$count]} -O ~/Desktop/datastuff/ria/${date}.txt");	
	}
	if($count==6){
	 	system("wget ${rssLinks[$count]} -O ~/Desktop/datastuff/itar-tass/${date}.txt");	
	}
	if($count==7){
	 	system("wget ${rssLinks[$count]} -O ~/Desktop/datastuff/aljazeera/${date}.txt");	
	}
 

} 

exit 0;
