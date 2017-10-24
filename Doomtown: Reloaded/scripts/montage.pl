#!/usr/bin/perl

use strict;
use warnings;

my $input = $ARGV[0];

mkdir ("../3x3");
`rm ../3x3/*.png`;
#`gm montage \@'$input' -monitor +adjoin -tile 3x3 -geometry +0+0 -density 300x300 '../3x3/%02d.png'`;
`gm montage \@'$input' -monitor +adjoin -tile 3x3 -geometry +0+0 -density 300x300 -quality 95 '../3x3/%02d.jpg'`;
