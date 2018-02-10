#!/usr/bin/perl

use strict;
use warnings;

my $set = $ARGV[0] or die "No set";
my $sheet = $ARGV[1];
my $myset = $set;
my $output = "/tmp/set_$myset.lst";
$set = '' if $set eq 'base';
die "Wrong set $set" if $set !~ /^(|S|K|BS|PBH|BA)$/;

open (INF, "<all_cards.csv") or die "$!";

my @front;
my @back;

<INF>;
while (my $line = <INF>) {
	$line =~ s/[\r\n]//g;
	my ($img, $set_id, $back_id) = split (/\t/, $line);
	die "Wrong set_id $set_id" if $set_id !~ /^(|S|K|BS|PBH|BA)$/;
	next if $img =~ /sheet_(STO|SET)/;
	$back_id = 'blank' if $back_id eq '';
	my $back_img = "../img_backs/$back_id.png";
	die "No file $img" if ! -f $img;
	die "No file $back_img" if ! -f $back_img;
	if ($set_id eq $set) {
		push (@front, $img);
		push (@back, $back_img);
	}
}
close (INF);

my $total = scalar(@front);
my $real_total = $total;
if ($total % 9) {
	my $remainder = 9 - ($total % 9);
	for (my $i = 0; $i < $remainder; ++$i) {
		push (@front, "../img_backs/blank_cross.png");
		push (@back, "../img_backs/blank.png");
	}
}
$total = scalar(@front);
my $total_sheets = int ($total / 9);
print "Card count = $real_total ($total), sheet count = $total_sheets\n";

for (my $i = 0; $i < $total_sheets; ++$i) {
	if (!defined ($sheet) or $sheet == $i) {
		open (OUT, ">$output") or die "$!";
		for (my $j = 0; $j < 9; ++$j) {
			print (OUT $front[$i * 9 + $j] . "\n");
		}
		print (OUT "\n");
		print (OUT $back[$i * 9 + 2] . "\n");
		print (OUT $back[$i * 9 + 1] . "\n");
		print (OUT $back[$i * 9 + 0] . "\n");
		print (OUT $back[$i * 9 + 5] . "\n");
		print (OUT $back[$i * 9 + 4] . "\n");
		print (OUT $back[$i * 9 + 3] . "\n");
		print (OUT $back[$i * 9 + 8] . "\n");
		print (OUT $back[$i * 9 + 7] . "\n");
		print (OUT $back[$i * 9 + 6] . "\n");
		print (OUT "\n");
		close (OUT);
		my $sheet_num = sprintf ('%02d', $i);
		my $cmd = "gm montage \@$output +adjoin -tile 3x3 -geometry +0+0 -density 300x300 '../3x3/$myset\_$sheet_num\_%d.png'";
		print "$cmd\n";
		`$cmd`;
	}
	#die;
}

exit;

