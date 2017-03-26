#!/usr/bin/perl

use strict;
use warnings;


my @csvs = qw (gevt guil inno sevt tw plot);

if (defined($ARGV[0])) {
	@csvs = ($ARGV[0]);
}

my $tempfile = '/tmp/android-pnp.tmp';

foreach my $csv(@csvs) {
	unlink ($tempfile);
	open (OUT, ">$tempfile") or die "$tempfile: $!";
	open (IN, "<$csv.csv") or die "$csv $!";
	print "Processing $csv:\n";
	while (my $line = <IN>) {
		$line =~ s/[\r\n]//g;
		my @field = split (/\t/, $line);
		if (!defined($field[0])) {
			print (OUT "\n");
			next;
		}
		if ($field[0] eq 'ex') {
			`cp -f img-exported/$field[1].png img-intermediate/$field[2].png`;
		}
		elsif ($field[0] eq 'tl') {
			`cp -f img-textless/$field[2].png img-intermediate/`;
		}
		else {
			die "Unknown value $field[0]";
		}
		print (OUT "img-intermediate/$field[2].png\n");
		#die $line;
	}
	close (IN);
	close (OUT);
	my $cmd = "gm montage \@$tempfile +adjoin -tile 3x3 -geometry +0+0 img-cards/$csv-%02d.png";
	print "$cmd\n";
	system ($cmd);
}
