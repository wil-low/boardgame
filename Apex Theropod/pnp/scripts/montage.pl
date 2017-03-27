#!/usr/bin/perl

use strict;
use warnings;
use JSON;
use Data::Dumper;

my @csv_files = qw (apex other multi);

if (defined ($ARGV[0])) {
	@csv_files = ($ARGV[0]);
}

for (@csv_files) {
	montage ($_);
}

sub montage {
	my ($csv) = @_;
	mkdir ("../3x3/$csv");
	`rm '../3x3/$csv/*.png'`;
	`gm montage \@'../csv/$csv.csv' -monitor +adjoin -tile 3x3 -geometry +0+0 '../3x3/$csv/%02d.png'`;
}
#print Dumper(\%decks);
#print Dumper(\%cards);