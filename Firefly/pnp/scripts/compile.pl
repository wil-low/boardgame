#!/usr/bin/perl

use strict;
use warnings;

my @tts_images = (
#	['0OM4XK6.jpg', 'nBS', 69, 4096, 4096], # nav Border  +
#	['0Tm6kui.jpg', 'sAD', 2, 4096, 4096], # Artful Dodger +
###	['1ABC0DCD65942F89019EA61C89F92B43A085ECA1_CNP-Alerts.png', 'pa', 10, 4096, ?], # Priority Alert
#	['2oRAN3f.jpg', 'sO1', 36, 4096, 4096], # supply Osiris Shipworks +
	['3P3nwzg.jpg', 'cHa', 45, 4096, 4096], # contact Harken + 
#	['51KP7aA.jpg', 'sP1', 39, 4096, 4096], # supply Persephone 1 +
#	['AdOBeLI.jpg', 'cBa', 45, 4096, 4096], # contact Badger +
#	['AeDHs7I.jpg', 'cN2', 5, 4096, 4096], # contact Niska 2 +
#	['aKQ8TBJ.jpg', 'sS1', 38, 4096, 4096], # supply Space Bazaar +
#	['BRPoAnO.jpg', 'cMH', 25, 4096, 4096], # contact Magistrate Higgins +
#	['CCp2tAI.jpg', 'nAS', 60, 4096, 4096], # nav Alliance +
#	['DfHOB2H.jpg', 'sS2', 5, 4096, 4096], # supply Space Bazaar 2 +
#	['Fbvsaz1.jpg', 'mbh', 40, 4096, 4096], # misbehave +
#	['gbA8iCy.jpg', 'sBM', 25, 4096, 4096], # supply Beaumonde +
#	['GfS3W8U.jpg', 'sBe', 25, 4096, 4096], # supply Meridian +
#	['gmnSPUy.jpg', 'cFM', 25, 4096, 4096], # contact Fanty&Mingo +
#	['gMVL0ey.jpg', 'cLH', 25, 4096, 4096], # contact Lord Harrow +
#	['iUyUlM0.jpg', 'cAD', 45, 4096, 4096], # contact Amnon Duul +
#	['lq2u6Pg.jpg', 'sR2', 5, 4096, 4096], # supply Regina 2 +
#	['nvXkALU.jpg', 'sH1', 36, 4096, 4096], # supply Silverhold +
#	['opJqtll.jpg', 'nBK', 61, 4096, 4096], # nav Border - Kalimasa +
#	['Q3CbqkR.jpg', 'sH2', 5, 4096, 4096], # supply Silverhold 2 +
#	['qj1FJLw.jpg', 'sO2', 5, 4096, 4096], # supply Osiris Shipworks +
#	['qM7kG8M.jpg', 'cPa', 45, 4096, 4096], # contact Patience +
#	['rB6X42l.jpg', 'aid', 5, 4096, 4096], # action aid +
#	['Ss3Fy03.jpg', 'SET', 6, 4096, 4096], # Setup cards +
#	['SZhahAK.jpg', 'DC1', 9, 4096, 4096], # Drive Core + Ship upgrade 1: back You can't take the sky from me +
#	['UBxcXCq.jpg', 'STO', 17, 4096, 4096], # Story cards +
#	['uHLTOxL.jpg', 'sP2', 5, 4096, 4096], # supply Persephone 2 +
#	['vgHeaJM.jpg', 'cN1', 40, 4096, 4096], # contact Niska 1 +
#	['VzMe3x6.jpg', 'sR1', 36, 4096, 4096], # supply Regina 1 +
#	['XcH1rc3.jpg', 'cU2', 3, 4096, 4096], # contact Mr Universe 2 +
#	['xIi7IhR.jpg', 'ALE', 20, 4096, 4096], # Alert +
#	['YBWjYLi.jpg', 'DC2', 3, 4096, 4096], # Drive Core + Ship upgrade 2: back You can't take the sky from me +
#	['Yh5d9Iq.jpg', 'cU1', 22, 4096, 4096], # contact Mr Universe 1 +
#	['zkM5joT.jpg', 'LEA', 13, 4096, 4096], # Leaders: back You can't take the sky from me
);

# Osiris, 

my %img_file;
my %img_id;
foreach my $ar (@tts_images) {
	if (defined ($img_file{$ar->[0]})) {
		die "img_file duplicate: $ar->[0]";
	}
	else {
		$img_file{$ar->[0]} = 1;
	}
	if (defined ($img_id{$ar->[1]})) {
		die "img_id duplicate: $ar->[1]";
	}
	else {
		$img_id{$ar->[1]} = 1;
	}
}

foreach my $ar (@tts_images) {
	process_sheet ($ar);
}

sub process_sheet {
	my @ar = @{$_[0]};
	my ($input, $sheet_id, $img_max, $img_width, $img_height) = @ar;
#=head
	my $img_count = 70;
	`rm ../sheets/sheet_$sheet_id-*.png`;
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
		my $cmd = sprintf ("gm convert ../../Firefly_TTS/$input -crop $w" . 'x' . "$h+$x0+$y0 +repage ../sheets/sheet_$sheet_id-%02d.png", $i);
		warn $cmd;
		`$cmd`;
	}
#=cut
#=head
	`rm ../img/sheet_$sheet_id-*.png`;
	my @pngs = glob ("../sheets/sheet_$sheet_id-*.png");
	my $counter = 0;
	foreach my $png (@pngs) {
		print "$png\n";
		my $out = $png;
		$out =~ s/sheets/img/;
		`gm convert $png -shave 1x1 -gravity north -geometry 741x1036^ -extent 741x1036 +repage $out`;
	}
#=cut
}
