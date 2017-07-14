#!/usr/bin/perl

use strict;
use warnings;

make_crops();
#make_backs();

sub make_crops {
	open (INF, "<cut.lst") or die $!;
	while (my $line = <INF>) {
		$line =~ s/[\n\r]//sg;
		my ($file, $cols, $rows, $count, $w, $h)= split (/\s+/, $line);
		print "$line\n";
		my $in = "../../tts/$file";
		my $out = $in;
		$out = "../tts-resized/crop/$file";
		$out =~ s/\.(jpg|png)//;
		my $info = `gm identify '$in'`;
	    $info =~ /(\d+)+x(\d+)\+0\+0/;
	    #die $info;
	    my $cutw = $1 / $cols;
	    my $cuth = $2 / $rows;
		my $counter = 0;
		my $cmd;
		my $frame;
		$frame = 'a' if ($file =~ /^(a\-|investment|demand|emergency)/);
		$frame = 'asset' if ($file =~ /^asset/);
		$frame = 'corp' if ($file =~ /^corp/);
		$frame = 'event' if ($file =~ /^(rival|event)/);
		$frame = 'setup' if ($file =~ /^setup/);
		$frame .= '-frame';
		$frame .= '-back' if ($file =~ /back/);
		next if $file !~ /emergency-back/;
		for (my $r = 0; $r < $rows; ++$r) {
			for (my $c = 0; $c < $cols; ++$c) {
				my ($x, $y) = ($c * $cutw, $r * $cuth);
				$cmd = sprintf ("gm convert '$in' -crop %dx%d+%d+%d -geometry %dx%d - | gm composite ../tts-resized/frame/$frame.png - +repage '/tmp/out.png'", $cutw, $cuth, $x, $y, $w, $h);
				print "$cmd\n";
				`$cmd`;
				$cmd = sprintf ("pngcrush -q -m 1 -res 300 /tmp/out.png $out-%03d.png", $counter);
				print "$cmd\n";
				`$cmd`;
				++$counter;
				last if $counter >= $count;
			}
			last if $counter >= $count;
		}
	}
	close (INF);
}

sub make_backs {
	my %backs = qw(
		a a
		asset asset
		demand a
		investment a
		rival event
		setup setup
	);

	foreach my $key (keys (%backs)) {
		my $value = $backs{$key};
		my $cmd = sprintf ("gm composite ../tts-resized/frame/$value-frame-back.png ../tts-resized/$key-back.png +repage /tmp/out.png");
		print "$cmd\n";
		`$cmd`;
		$cmd = sprintf ("pngcrush -q -m 1 -res 300 /tmp/out.png ../tts-resized/crop/$key-back.png");
		print "$cmd\n";
		`$cmd`;
	}
}
