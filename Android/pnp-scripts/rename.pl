use strict;
use warnings;

my @files = glob("../output/*.png");
foreach my $file (@files) {
	my $new_file = $file;
	if ($new_file =~ /(.+?)\-(\d\..+)/) {
		$new_file = "$1-0$2";
		print "$new_file vs $file\n";
		`mv $file $new_file`;
	}
}