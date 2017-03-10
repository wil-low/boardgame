use strict;
use warnings;

open (IN, "<$ARGV[0]") or die $!;
while (my $line = <IN>) {
	# valign=middle for PlotTite
	$line =~ s/(<PAGEOBJECT[^>]+?VAlign)="0"([^>]+?PSTYLE="GoodBadTitle"[^>]+?>)/$1="1"$2/;
	#$line =~ s/\{\{([^>]+?)\}\}/"\/><ITEXT FONT="Times New Roman Bold Italic" CH="$1"\/><ITEXT CH="/g;
	#$line =~ s/\[\[([^>]+?)\]\]/"\/><ITEXT FONT="Times New Roman Italic" CH="$1"\/><ITEXT CH="/g;
	#$line =~ s/\$(\d+)/$1\$/g;

	#$line =~ s/(<PAGEOBJECT[^>]+?VAlign)="2"([^>]+?PSTYLE="PlotTitle"[^>]+?>)/$1="1"$2/;
	print $line;
}
=head

<ITEXT CH="{{Бой, Охота за головами}}: Играйте, "/>
                <ITEXT FONT="Times New Roman Italic" CH="когда"/>
                <ITEXT CH=" Рэйчел входит в богатую локацию."/>


                "/>
                <ITEXT FONT="Times New Roman Bold Italic" CH="отправляется"/>
                <ITEXT CH="

=cut