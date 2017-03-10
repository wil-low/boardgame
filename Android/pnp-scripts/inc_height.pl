use strict;
use warnings;
use Data::Dumper;
use XML::Twig;

my @pages;
my ($image_x, $image_y) = ('', '');

my $twig=XML::Twig->new(
	keep_encoding => 1,
	twig_handlers => {
		PAGEOBJECT => \&pageobject
	}
);

$twig->parsefile($ARGV[0]); # build it

#print Dumper(@pages);
$twig->print();

sub pageobject {
	my ($twig, $obj) = @_;
	my $ptype = $obj->att('PTYPE');
	my $pcolor = $obj->att('PCOLOR');
	my $pstyle = $obj->att('PSTYLE');

	if ($ptype != 4) {
		return;
	}
	#die $pfile;
	my $copy = $obj->copy();
	if ($pstyle eq 'GoodBadTitle' and ($pcolor eq 'White' or $pcolor eq 'Grey2')) {
		$obj->set_att('YPOS', $obj->att('YPOS') + 0.3);
		warn $obj->att('YPOS'), $pcolor;
	}
}

