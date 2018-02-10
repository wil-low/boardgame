#!/usr/bin/perl

use strict;
use warnings;

my ($csv) = @_;
`gm montage \@crosses.lst -monitor +adjoin -tile 3x3 -geometry +0+0 -quality 100% -density 300 -background none '../back_frame3x3.png'`;
