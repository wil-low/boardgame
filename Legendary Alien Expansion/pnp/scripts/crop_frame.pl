#!/usr/bin/perl

use strict;
use warnings;

my @in = glob ('../img_export/*.png');
foreach my $i (@in) {
	process_image ($i);
}

sub process_image {
	my ($in) = shift;
	my $out = $in;
	$out =~ s/_export/_crop/;
	my $cmd = "gm convert $in -crop 741x1036 +repage - | gm composite ../crosses.png - $out";
	warn $cmd;
	`$cmd`;
}
