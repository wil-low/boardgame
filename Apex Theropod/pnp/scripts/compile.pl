#!/usr/bin/perl

use strict;
use warnings;

my @tts_images = (
	#['httpiimgurcom6nJuIw2jpg.jpg', 1, 70, 500, 700, 486, 686, 8, 8],
	#['httpiimgurcomhBvoqQKjpg.jpg', 2, 70, 500, 695, 486, 686, 8, 8],
	#['httpiimgurcomoBnJoo6jpg.jpg', 3, 36, 500, 700, 486, 686, 8, 8],
	#['httpiimgurcomPk3tA8ujpg.jpg', 4,  2, 500, 700, 486, 686, 8, 8],
	#['httpiimgurcomsRZWuRKjpg.jpg', 5, 70, 500, 700, 486, 686, 8, 8],
	['httpiimgurcomV5r4dKkjpg.jpg', 6, 59, 500, 695, 486, 686, 8, 8],
	#['httpiimgurcomyBH0Kzmjpg.jpg', 7, 41, 500, 700, 486, 686, 8, 8],
);

foreach my $ar (@tts_images) {
	process_sheet ($ar);
}

sub process_sheet {
	my @ar = @{$_[0]};
	my ($input, $sheet_num, $img_count) = @ar;
	`rm ../sheets/sheet$sheet_num-*.png`;
	`gm convert ../../tts/$input +adjoin -crop $ar[3]x$ar[4] +repage ../sheets/sheet$sheet_num-%02d.png`;
#exit;
	`rm ../img/sheet$sheet_num-*.png`;
	my @pngs = glob ("../sheets/sheet$sheet_num-*.png");
	my $counter = 0;
	foreach my $png (@pngs) {
		print "$png\n";
		my $out = $png;
		$out =~ s/sheets/img/;
		`gm convert $png -crop $ar[5]x$ar[6]+$ar[7]+$ar[8] -geometry 750x1050 -extent 750x1050 +repage - | gm composite ../frame.png - $out`;
		++$counter;
		last if $counter >= $img_count;
	}
}
