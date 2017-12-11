#!/usr/bin/perl

use strict;
use warnings;

open (IN, "<../LE:Alien_expansion_cards.csv") or die "$!";
<IN>;
while (my $line = <IN>) {
	my @field = split (/\t/, $line);
	my $out = sprintf ("../img_crop/card-page%03d.png", $field[0]);
	for (my $i = 0; $i < $field[5]; ++$i) {
		print "$out\n";
	}
}
close (IN);
