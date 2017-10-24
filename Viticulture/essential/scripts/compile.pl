#!/usr/bin/perl

use strict;
use warnings;

my @export = glob ('../export/visitors-page*.png');

foreach my $img (@export) {
	$img =~ /(visitors-page\d+\.png)/;
	my $out = "../img-crosses/$1";
	`gm composite ../signs/crosses.png $img $out`;
	print "$out\n";
}

my $cmd = "gm montage \@cards.lst +adjoin -tile 4x4 -geometry +0+0 ../4x4/%02d.png";
print "$cmd\n";
system ($cmd);
