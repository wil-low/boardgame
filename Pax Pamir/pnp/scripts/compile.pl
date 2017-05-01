#!/usr/bin/perl

use strict;
use warnings;

open (INF, "<../cards_list.txt") or die $!;
while (my $png = <INF>) {
	$png =~ s/[\r\n]//sg;
	print "$png\n";
	my $out = $png;
	$out =~ s/\.\.\/images/img/;
	$out =~ s/ /_/sg;
	$out =~ s/\.jpg/\.png/s;
	my $info = `gm identify '$png'`;
	$info =~ /(\d+x\d+)\+0\+0/;
#	if ($1 ne '272x402') {
#		warn $info;
#	}
	my $frame = 'frame-exp.png';
	if ($png =~ /\/\d[^\/]+$/) {
		$frame = 'frame.png';
	}
	`gm convert '$png' -geometry 710x1050 -enhance -contrast -gravity center -extent 710x1050 -density 300x300 +repage - | gm composite ../$frame - '$out'`;
	#last;
}
close (INF);
