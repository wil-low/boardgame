#!/usr/bin/perl

use strict;
use warnings;

open (IN, "<../card_template/card_template.csv") or die "$!";
<IN>;
print << 'END';
Image	Expansion	Back	Special Set
#BLANK	blank.png
#TILE	3x3
#FRAME_FRONT	frame_front.png
END
while (my $line = <IN>) {
	my @field = split (/\@/, $line);
	my $out = sprintf ("../img_crop/Firefly-page%03d.png", $field[1]);
	for (my $i = 0; $i < $field[6]; ++$i) {
		print "$out\tBase\n";
	}
}
close (IN);
