#!/usr/bin/perl

use strict;
use warnings;

my ($csv) = @_;
mkdir ("../3x3");
`rm ../3x3/*`;
`gm montage \@cards.lst -monitor +adjoin -tile 3x3 -geometry +0+0 -density 300x300 '../3x3/%02d.png'`;
