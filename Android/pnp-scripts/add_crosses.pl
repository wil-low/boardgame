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
	my $pfile = $obj->att('PFILE');

	if ($ptype != 2) {
		return;
	}
	#die $pfile;
	my $copy = $obj->copy();
	if (defined($copy->att('ItemID'))) {
		$copy->set_att('ItemID', '9' . $copy->att('ItemID'));
	}
	$copy->set_att('PFILE', 'crosses.png');
	$copy->paste_after($obj);
}

