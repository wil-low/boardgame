use strict;
use warnings;

`rm crops/*.png`;

#crop ('img/tile/actions-FRONT.jpg', 10, 7, 'actf', 0);
#crop ('img/tile/actions_BACK.jpg', 10, 7, 'actb', 0);
#crop ('img/tile/playbills-BACK.jpg', 10, 7, 'playb', 0);
#crop ('img/tile/playbills-FRONT.jpg', 10, 7, 'playf', 0);
crop ('img/tile/tricks-FRONT.jpg', 10, 7, 'trf', 2);
#crop ('img/tile/tricks-BACK.jpg', 10, 7, 'trb', 2);
#crop ('img/tile/specialside-FRONT.jpg', 10, 7, 'sp1f', 0);
#crop ('img/tile/specialside2-FRONT.jpg', 10, 7, 'sp2f', 0);


sub crop {
	my ($img, $col, $row, $prefix, $premargin) = @_;
	my $info = `gm identify -format '%w %h' $img`;
	$info =~ /(\d+) (\d+)/;
	my $width = ($1 - $premargin * 2) / $col;
	my $height = ($2 - $premargin * 2)/ $row;
	warn ("$width $height");
	my $xf = $premargin;
	my $yf = $premargin;
	my $margin = 2;
	my $counter = 0;
	for (my $i = 0; $i < $row; ++$i) {
		for (my $j = 0; $j < $col; ++$j) {
			my $x = int (($xf + $width * $j) + 0.5);
			my $y = int (($yf + $height * $i) + 0.5);
			$x -= $margin;
			$y -= $margin;

			my $w = int ($width + $margin * 2 + 0.5);
			my $h = int ($height + $margin * 2 + 0.5);

			my $cmd = sprintf ("gm convert %s -crop %dx%d%+d%+d -density 300x300 +repage crops/%s-%02d.png", $img, $w, $h, $x, $y, $prefix, $counter);
			print "$cmd\n";
			system ($cmd);
			++$counter;
		}
	}
	#die;
}

