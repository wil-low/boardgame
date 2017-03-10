use strict;
use warnings;

my @img;
open (INF, "<../output.txt") or die $!;
while (my $line = <INF>) {
	$line =~ s/[\r\n]//g;
	push (@img, $line);
}
close (INF);

open (INF, "<../Android_PnP_EN_cards.sla") or die $!;
my @data = <INF>;
close (INF);
my $content = join ('', @data);
my $out = '';
my $counter = 0;
while ($content =~ s/(.+?)gg\.png//s) {
	$out .= "$1$img[$counter]";
	++$counter;
}

$out .= $content;

open (OUTF, ">../Android_PnP_EN_cards_new.sla") or die $!;
print (OUTF $out);
close($out);
