#!/usr/bin/perl

use strict;
use warnings;

my ($csv) = @_;
mkdir ("../3x3");
`rm ../3x3/*`;
`gm montage \@cards.lst -monitor +adjoin -tile 3x3 -geometry +0+0 -quality 97% '../3x3/%02d.jpg'`;
