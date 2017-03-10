use strict;
use warnings;
use Data::Dumper;
use XML::Twig;

my @pages;
my ($image_x, $image_y) = ('', '');

my $twig=XML::Twig->new(
	keep_encoding => 1,
	twig_handlers => {
		PAGEOBJECT => \&pageobject,
		PAGE => \&page
	}
);

$twig->parsefile($ARGV[0]); # build it

#print Dumper(@pages);
$twig->print();

sub pageobject {
	my ($twig, $obj) = @_;
	my $pstyle = $obj->att('PSTYLE');
	my $pfile = $obj->att('PFILE');

	if (defined($pstyle) and $pstyle eq 'Annotation') {
		$obj->delete();
		return;
	}
	if (defined($pfile) and $pfile =~ /annotated/) {
		$obj->delete();
		return;
	}

	my $own_page = $obj->att('OwnPage');
	if ($own_page == -1) {
		$obj->delete();
		return;
	}
	my $page_x = $pages[$own_page]->{x};
	my $page_y = $pages[$own_page]->{y};
	my ($x, $y, $w, $h) = ($obj->att('XPOS'), $obj->att('YPOS'), $obj->att('WIDTH'), $obj->att('HEIGHT'));
	my $center_x = $x + $w / 2;
	my $center_y = $y + $h / 2;
	for (my $i = 0; $i < scalar(@pages); ++$i) {
		if ($pages[$i]->{y} < $center_y and $center_y < $pages[$i]->{y} + $pages[$i]->{h}) {
			$own_page = $i;
			if (defined($pfile) and $pfile =~ /img\/frame/) {
				if ($image_x eq '') {
					$image_x = $x - $pages[$i]->{x};
					$image_y = $y - $pages[$i]->{y};
				}
				#warn "$pfile: XPOS => $x, YPOS => $y, OwnPage => $own_page, Pagenumber => $own_page\n";

			}
			if ($image_x eq '') {
				die $obj->att('ItemID');
			}
			$x = $x - $image_x;
			$y = $y - $image_y;
			$obj->set_att(XPOS => $x, YPOS => $y, OwnPage => $own_page, Pagenumber => $own_page);
			last;
		}
	}
	#print $obj->att('OwnPage') . ' ' . $obj->att('XPOS') . ' ' . $obj->att('YPOS') . "\n";
}

sub page {
	my ($twig, $page) = @_;
	$pages[$page->att('NUM')] = {x => $page->att('PAGEXPOS'), y => $page->att('PAGEYPOS'), w => $page->att('PAGEWIDTH'), h => $page->att('PAGEHEIGHT')};
	warn "PAGE: " . $page->att('NUM') . ' ' . $page->att('PAGEXPOS') . ' ' . $page->att('PAGEYPOS') . "\n";
}

=head
my $out = '';
my ($XPOS, $YPOS) = ('', '');
while (my $line = <IN>) {
	# valign=middle for PlotTite
	next if $line =~ /<ITEXT CH=\"Orig:/;
	next if $line =~ /\/annotated\//;
	$line =~ s/PAGEWIDTH="[\d\.\-]+"/PAGEWIDTH="161.52"/;
	$line =~ s/PAGEHEIGHT="[\d\.\-]+"/PAGEHEIGHT="247.92"/;
	if ($line =~ s/(.*?<PAGEOBJECT XPOS=")([\d\.\-]+)" YPOS="([\d\.\-]+)"//) {
		my ($begin, $x, $y) = ($1, $2, $3);
		if ($XPOS eq '') {
			$XPOS = $x;
			$YPOS = $y;
			$x = '0';
			$y = '0';
		}
		else {
			$x -= $XPOS;
			$y -= $YPOS;
		}
		$line = "$begin$x\" YPOS=\"$y\"" . $line;
	}
	$out .= $line;
}

my $out2 = '';
while ($out =~ s/(.*?)(<PAGEOBJECT.+?<\/PAGEOBJECT>)//s) {
	$out2 .= $1;
	my $obj = $2;
	next if $obj =~ /PSTYLE="Annotation"/;
	$out2 .= $obj;
}
$out2 .= $out;
print $out2;
=cut
