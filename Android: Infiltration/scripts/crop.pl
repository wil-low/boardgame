use strict;
use warnings;

my %crops = (
	action => [3, 3, 520, 800],
	item => [3, 3, 520, 800],
	small => [3, 3, 520, 800],
	proto => [3, 3, 520, 800],
	blackmail => [3, 3, 520, 800],
	sewage => [3, 3, 520, 800],
	npc => [3, 3, 800, 520],
	operative => [1, 1, 1414, 811],
	room => [1, 1, 811, 1414],
	);

foreach my $img (glob ('../img_text/*.png')) {
	my $out = $img;
	$out =~ s/img_text/img_crop/s;
	$out =~ s/\.png/\.jpg/s;
	$img =~ /.+\/(\w+)\-(page|back)/;
	my $type = $1;
	my @g = @{$crops{$type}};
	my $cmd = "gm convert $img -crop $g[2]x$g[3]+$g[0]+$g[1] -quality 95 $out";
	print "$cmd\n";
	system ($cmd);
	#die;
}


