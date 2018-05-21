#!/usr/bin/perl

# Extract assets from a Tabletopia game

# Original idea: hickname
# Perl implementation: wil_low
# Packages required: libjson-perl, graphicsmagick 

# Usage: perl tabletopia_cutter.pl src_dir tgt_dir

use strict;
use warnings;
use JSON;
#use Data::Dumper;

my ($src_dir, $tgt_dir) = @ARGV;

die "perl tabletopia_cutter.pl src_dir tgt_dir" unless defined $ARGV[1];

mkdir($tgt_dir);

my @files = glob("$src_dir/*");

my $manifest;

for my $file (@files) {
	if ($file =~ /g\d{6}_s\d{5}\.sprite(\d+)/) {
		my $new_file = "Image_$1_Atlas.jpg";
		`cp $file $tgt_dir/$new_file`;
	}
	elsif ($file =~ /manifest_bundled/) {
		$manifest = "$tgt_dir/manifest_bundled.txt";
		`cp $file $manifest`;
	}
}

die "Manifest not found" unless $manifest;

my @paths = qw(other cards tiles tokens counters boards gamepieces standees);
for (@paths) {
	mkdir ("$tgt_dir/$_");
}

open (IN, "<$manifest") or die "$!: $manifest";
my @data = <IN>;
close (IN);

my $json = JSON->new->allow_nonref;

my $hash = $json->decode(join('', @data));
#print Dumper($hash);
#exit;

my $fname = "$tgt_dir/other/elements.txt";
open (ELEM, ">$fname") or die "$!: $fname";

for my $obj (@$hash) {
	#print Dumper($obj);
	my $type = 0;
	$type = 1 if ($obj->{elementType} eq "Cards");
	$type = 2 if ($obj->{elementType} eq "Tiles");
	$type = 3 if ($obj->{elementType} eq "Tokens");
	$type = 4 if ($obj->{elementType} eq "Counters");
	$type = 5 if ($obj->{elementType} eq "Boards");
	$type = 6 if ($obj->{elementType} eq "GamePieces");
	$type = 7 if ($obj->{elementType} eq "VerticalTokens");

	if ($type == 6) {
		# save GamePieces object
		if ($obj->{representation} eq "ModelReconstruction") {
			my $fname = "$tgt_dir/gamepieces/" . $obj->{elementId} . ".obj";
			print ("type $type: model $fname\n");
			open (OUT, ">$fname") or die "$!: $fname";
			print (OUT $obj->{modelReconstruction}->{obj});
			close (OUT);
		}
	}
	elsif ($type == 7) {
		# save VerticalTokens object
		my $fname = $obj->{atlases}->[0]->{resource}->{id} . ".jpg";
		my ($h, $w, $x, $y) = (0, 0, 0, 0);
		# token
		my $rect = $obj->{atlases}->[0]->{sprites}->[0];
		$h = $rect->{height};
		$w = $rect->{width};
		$x = $rect->{x};
		$y = $rect->{y};
		my $cmd = "gm convert $tgt_dir/$fname -crop $w" . 'x' . "$h+$x+$y $tgt_dir/$paths[$type]/$obj->{elementId}_token.png";
		print ("type $type: $cmd\n");
		`$cmd`;
		# standee
		$rect = $obj->{atlases}->[1]->{sprites}->[0];
		$h = $rect->{height};
		$w = $rect->{width};
		$x = $rect->{x};
		$y = $rect->{y};
		$cmd = "gm convert $tgt_dir/$fname -crop $w" . 'x' . "$h+$x+$y $tgt_dir/$paths[$type]/$obj->{elementId}_stand.png";
		print ("type $type: $cmd\n");
		`$cmd`;
	}
	elsif ($type) {
		my $fname = $obj->{atlases}->[0]->{resource}->{id} . ".jpg";
		my ($h, $w, $x, $y) = (0, 0, 0, 0);
		# get coords
		my $rect = $obj->{atlases}->[0]->{sprites}->[0];
		$h = $rect->{height};
		$w = $rect->{width};
		$x = $rect->{x};
		$y = $rect->{y};
		# save front side
		my $cmd = "gm convert $tgt_dir/$fname -crop $w" . 'x' . "$h+$x+$y $tgt_dir/$paths[$type]/$obj->{elementId}_front.png";
		print ("type $type: $cmd\n");
		`$cmd`;
		# save back side if it exists
		if ($type != 4) {
			$rect = $obj->{atlases}->[0]->{sprites}->[1];
			if (defined ($rect)) {
				$h = $rect->{height};
				$w = $rect->{width};
				$x = $rect->{x};
				$y = $rect->{y};
				my $cmd = "gm convert $tgt_dir/$fname -crop $w" . 'x' . "$h+$x+$y $tgt_dir/$paths[$type]/$obj->{elementId}_back.png";
				print ("type $type: $cmd\n");
				`$cmd`;
			}
		}
	}
	# save object name and group contents
	if ($type > 2) {
		print (ELEM "$obj->{elementId} - $obj->{elementName}\n");
	}
	if ($obj->{elementType} eq "RandomElement") {
		my $m = $obj->{randomElementInfo}->{groupName};
		$m =~ s/[\\\ \"\/:*?<>\|]/_/g;
		$fname = "$tgt_dir/other/$obj->{elementId}_$m.txt";
		open (OUT, ">$fname") or die "$!: $fname";
		for ($obj->{randomElementInfo}->{elementIds}) {
			print (OUT "$_\n");
		}
		close (OUT);
	}
}
close (ELEM);
for (@paths) {
	rmdir ("$tgt_dir/$_");
}
