#!/usr/bin/perl

use strict;
use warnings;

my @tts_images = (
	['0-httpsiimgurcomABoeQ2ojpg.jpg', 0, 70, 4991, 4954],
	['5-httpsiimgurcomLI70B5Wjpg.jpg', 5, 69, 4991, 4954],
	['8-httpsiimgurcomVUMaHhKjpg.jpg', 8, 70, 4278, 4246],
);

foreach my $ar (@tts_images) {
	process_sheet ($ar);
}

sub process_sheet {
	my @ar = @{$_[0]};
	my ($input, $sheet_num, $img_count, $img_width, $img_height) = @ar;
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
	for (my $i = 0; $i < $img_count; ++$i) {
		my $row = int ($i / 10);
		my $col = $i % 10;
		my $x0 = int ($col * $dw + 0.5);
		my $y0 = int ($row * $dh + 0.5);
		my $x1 = int (($col + 1) * $dw + 0.5);
		my $y1 = int (($row + 1) * $dh + 0.5);
		my $w = $x1 - $x0;
		my $h = $y1 - $y0;
		my $cmd = sprintf ("gm convert ../../tts/$input -crop $w" . 'x' . "$h+$x0+$y0 +repage ../sheets/sheet$sheet_num-%02d.png", $i);
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
