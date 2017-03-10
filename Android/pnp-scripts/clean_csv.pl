use strict;
use warnings;

my %persons = qw(louis Луис floyd Флойд rachel Рэйчел raymond Рэймонд caprice Каприс);

my %subtitle = (
	'caprice-o' => 'Любовь',
	'caprice-g' => 'Помешательство',
	'caprice-b' => 'Собственность Джинтеки',
	'floyd-o' => 'В поисках себя',
	'floyd-g' => 'Не убий',
	'floyd-b' => 'Собственность Хаас',
	'louis-g' => 'Взяточничество',
	'louis-o' => 'Сара',
	'louis-b' => 'Дело Крэйси',
	'rachel-g' => 'День отца',
	'rachel-b' => '…Познается в беде',
	'rachel-o' => 'Верный друг...',
	'raymond-b' => 'Призраки прошлого',
	'raymond-g' => 'Старая любовь'
	);

my $type = $ARGV[0];
open (IN, "<$type.csv") or die $!;
my $line = <IN>;  # skip 1st line
print $line;
while ($line = <IN>) {
	$line =~ s/\|\t/\t/g;
	$line =~ s/\&amp;/&/g;
	$line =~ s/"/\&quot;/g;
	#$line =~ s/\|/\x0a/g;
	if ($type =~ /(gevt|murd)/) {
		my @fields = split(/\t/, $line);
		my @img = glob(sprintf("annotated/%03d-*", $fields[2]));
		$img[0] =~ s/annotated\///;
		$fields[2] = $img[0];
		$line = join ("\t", @fields);
	}
	elsif ($type =~ /plot/) {
		my @fields = split(/\t/, $line);
		my @img = glob(sprintf("annotated/%03d-*", $fields[2]));
		$img[0] =~ s/annotated\///;
		$fields[2] = $img[0];
		$fields[6] =~ s/^(\d)/\+$1/;
		if ($fields[6] ne '') {
			$fields[6] .= 'vp';
		}
		$line = join ("\t", @fields);
	}
	elsif ($type =~ /tw/) {
		$line =~ s/<b>/{{/g;
		$line =~ s/<\/b>/}}/g;
		$line =~ s/<i>/[[/g;
		$line =~ s/<\/i>/]]/g;
		my @fields = split(/\t/, $line);
		my @img = glob(sprintf("annotated/%03d-*", $fields[2]));
		$img[0] =~ s/annotated\///;
		$fields[1] =~ s/^&quot;//;
		$fields[1] =~ s/&quot;$//;
		$fields[7] = $subtitle{"$fields[3]-$fields[5]"};
		$fields[2] = $img[0];
		if ($fields[4] eq 'L') {
			$fields[3] = '';
			$fields[9] = $fields[8];
			$fields[8] = '';
		}
		else {
			$fields[3] = $persons{$fields[3]};
		}
		$line = join ("\t", @fields);
	}
	else {
		die "Unknown type $type";
	}
	print $line;
}