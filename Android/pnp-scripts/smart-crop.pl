use strict;
use warnings;

my $source = $ARGV[0];
my $prefix = $ARGV[1];
my $test = $ARGV[2];
die "prefix undefined" if !defined($prefix);

if (defined($test)) {
	process_file ("$source/$test.jpg", 1);
	exit;
}

my $dest = '../pnp';
`rm $dest/$prefix*`;

print "prefix: $prefix\n";

my @files = glob("'$source/*.jpg'");
#die @files;
foreach my $file (@files) {
	process_file ($file, 0);
}

sub convert_fn
{
	my $frame_type = 'f';
	my $file = shift;
	$file =~ /.+\/(.+?)\./;
	$file = $1;
	if ($file =~ /^\d$/) {
		$file = '0' . $file;
	}
	if ($file =~ /back/) {
		$frame_type = 'b';
	}
	return ($file, $frame_type);
}

sub process_file
{
	my ($file, $is_test) = @_;
	print "$file\n";
	my ($new_file, $frame_type) = convert_fn($file);
	#die $new_file;
	my $cmd = "/home/willow/program/deskew64 '$file'";
	#die $cmd;
	if ($is_test) {
		system($cmd);
		`convert out.png null: ../border-grey.png -layers Composite 1.png `;
		`convert 1.png -fuzz 40% -trim 2.png`;
	}
	else {
		`$cmd`;
		`convert out.png null: ../border-grey.png -layers Composite -fuzz 40% -trim -gravity Center -extent '673x1033' +repage null: ../frame-$frame_type.png -layers Composite $dest/$prefix-$new_file.png`;
	}
	if (!$is_test) {
		unlink 'out.png';
	}
}