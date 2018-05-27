#!/usr/bin/perl

use strict;
use warnings;

my @tts_images = (
	['204xfS2.jpg', 0, 24, 6692, 6552],
	['IthVwrl.jpg', 1, 3, 6692, 6552],
	['rICosqz.jpg', 2, 62, 5354, 5242],
	['savGV4O.jpg', 3, 62, 4758, 4659],
	['SPcL5lZ.jpg', 4, 30, 6692, 6552],
	['uADNAF0.jpg', 5, 45, 5948, 5824],
	['XgpmGRD.jpg', 6, 5, 7435, 7280],
);

foreach my $ar (@tts_images) {
	process_sheet ($ar);
}

sub process_sheet {
	my @ar = @{$_[0]};
	my ($input, $sheet_num, $img_max, $img_width, $img_height) = @ar;
	my $img_count = 70;
#=head
	`rm ../sheets/sheet$sheet_num-*.png`;
	my $dw = $img_width / 10;
	my $rounded_up_count = $img_count % 10;
	if ($rounded_up_count > 0) {
		$rounded_up_count = $img_count + 10 - $rounded_up_count;
	}
	else {
		$rounded_up_count = $img_count;
	}
	my $dh = $img_height / $rounded_up_count * 10;
	#die "$dw; $dh";
	for (my $i = 0; $i < $img_max; ++$i) {
		my $row = int ($i / 10);
		my $col = $i % 10;
		my $x0 = int ($col * $dw + 0.5);
		my $y0 = int ($row * $dh + 0.5);
		my $x1 = int (($col + 1) * $dw + 0.5);
		my $y1 = int (($row + 1) * $dh + 0.5);
		my $w = $x1 - $x0;
		my $h = $y1 - $y0;
		my $cmd = sprintf ("gm convert ../tts/$input -crop $w" . 'x' . "$h+$x0+$y0 +repage ../sheets/sheet$sheet_num-%02d.png", $i);
		warn $cmd;
		`$cmd`;
	}
#=cut
	`rm ../img/sheet$sheet_num-*.png`;
	my @pngs = glob ("../sheets/sheet$sheet_num-*.png");
	my $counter = 0;
	foreach my $png (@pngs) {
		print "$png\n";
		my $out = $png;
		$out =~ s/sheets/img/;
		`gm convert $png -shave 1x1 -gravity north -geometry 741x1036^ -extent 741x1036 +repage $out`;
	}
}
