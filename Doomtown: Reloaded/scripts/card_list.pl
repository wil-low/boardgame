#!/usr/bin/perl

use strict;
use warnings;

open (OUT, ">card_map.csv");
print (OUT "num\timage\ttitle\n");

my @htmls = glob ('../doomtowndb/*.html');
foreach (@htmls) {
	process_html ($_);
#	last;
}

sub process_html {  # html filename
	my $in = shift;
	open (IN, "<$in") or die $!;
	my @data = <IN>;
	close (IN);
	my $text = join ('', @data);
	my @cards = split (/<div class="row" style="margin-top:2em">/s, $text);
	foreach my $card (@cards) {
		next if $card !~ /<div class="card-image">(.+?)<\/div>/s;
		my $image = $1;
		$image =~ /<img src="(.+?)"/;
		$image = $1;
		$card =~ /class="card-title">(.+?)<\/a>/;
		my $title = $1;
		$card =~ /Base Set #(\d+)/;
		my $num = $1;
		die $card if !defined($image) or !defined($title) or !defined($num);

		print (OUT "$num\t../doomtowndb/$image\t$title\n");
	} 
}
close (OUT);
