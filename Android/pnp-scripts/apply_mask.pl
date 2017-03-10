#!/usr/bin/perl

use strict;
use warnings;
use List::Util 1.33 'any';

my @maskless = qw (
001-000
004-065
009-275
010-295
011-317
013-356
014-376
015-411
016-439
018-483
018-485
019-503
020-526
021-551
022-578
022-580
022-582
022-584
022-586
023-609
024-635
025-671
025-678
026-694
027-730
028-761
030-802
031-826
032-846
034-895
035-929
036-955
038-1001
039-1025
041-1064
044-1104
044-1107
045-1152
045-1155
);

my @jpgs = glob ('img/*.jpg');

foreach my $jpg (@jpgs) {
	if ($jpg !~ /img\-((\d\d\d)-(\d\d\d\d?))/) {
		next;
	}
	my $id = $1;
	my $page = $2;
	my $num = $3;
	my $is_found = any {/$id/} @maskless;
	if ($is_found) {
		my $outf = $jpg;
		$outf =~ s/img\//out\//s;
		print "cp -f $jpg $outf\n";
		next;
	}
	my $jpg_size = img_size($jpg);
	my @pngs = glob ("png/img-$page-*.png");
	my $found = 0;
	foreach my $png (@pngs) {
		if ($jpg_size eq img_size($png)) {
			apply_mask ($jpg, $png);
			$found = 1;
			last;
		}
	}
	if (!$found) {
		$num++;
		my $mask = "new/img-$page-$num.jpg";
		if (! -f $mask) {
			$mask =~ s/\.jpg/\.png/;
		}
		if (-f $mask and $jpg_size eq img_size($mask)) {
			apply_mask ($jpg, $mask);
		}
		else {
			warn "$id\n";
		}
	}
}

sub img_size {  # $image
	my $props = `identify $_[0]`;
	$props =~ /(?:JPEG|PNG)\s(\d+x\d+)/;
	return $1;
}

sub apply_mask { # 	image, mask
	my ($image, $mask) = @_;
	my $output = $image;
	$output =~ s/\.jpg/\.png/;
	$output =~ s/img\//out\//s;
	print "gm composite -compose CopyOpacity $mask $image $output\n";
}
