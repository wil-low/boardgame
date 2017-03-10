use strict;
use warnings;

open (IN, "<$ARGV[0]") or die $!;
my @content = <IN>;
close(IN);

mkdir('annotated');
my $counter = 0;
foreach my $line (@content) {
	$line =~ /.+\/(.+?)\.png/;
	my $title = $1;
	next if !defined($title) or $title =~ /(blank|back)/;
	$line =~ s/[\r\n]//sg;
	$title = sprintf('%03d-%s', $counter++, $title);
	my $cmd = "convert -background '#0008' -gravity center -fill white -size 1000x30 caption:\"$title\" $line +swap -gravity south -composite annotated/$title.png";
	#print "$cmd\n";
	print "$title\n";
	system ($cmd);
	#die;
}


