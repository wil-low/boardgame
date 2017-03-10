use strict;
use warnings;

open (IN, "<$ARGV[0]") or die $!;
while (my $line = <IN>) {
	$line =~ s/\&amp;quot;/&quot;/g;
	$line =~ s/\|/"\/><para\/><ITEXT CH="/sg;
	$line =~ s/<PAGEOBJECT[^>]+>\s*<\/PAGEOBJECT>//g;
	print $line;
}
