#!/usr/bin/perl

use strict;
use warnings;

open (OUT, '>print.txt');

mkdir ('../img_all');
`rm ../img_all/*`;
open (INF, "<../doomtown_reloaded_v125.csv") or die $!;
while (my $line = <INF>) {
	my @fld = split (/\t/, $line);
	next if $fld[0] !~ /^\d+$/;
	my $out = sprintf ('../img_all/%03d.png', $fld[0]);
	my $image = $fld[1];
	print "$fld[0]: $image\n"; 
	`gm convert $image -geometry 686x960 -gravity center -extent 686x958 -density 300x300 +repage - | gm composite ../frame.png - '$out'`;
	for (my $i = 0; $i < $fld[3]; ++$i) {
		print (OUT "$out\n");
	}
	#last;
}
close (INF);
close (OUT);
