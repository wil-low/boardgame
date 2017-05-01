#!/usr/bin/perl

use strict;
use warnings;

mkdir ("../3x3");
`rm ../3x3/*.png`;
`gm montage \@'partial_print.txt' -monitor +adjoin -tile 3x3 -geometry +0+0 -density 300x300 '../3x3/%02d.png'`;
