use strict;
use warnings;
use Data::Dumper;

my $counter = 100;

my $card_counter = 0;

my $outfile = $ARGV[1];
die "No outfile!" if !defined ($outfile);

open (IN, "<$ARGV[0]") or die $!;
my @content = <IN>;
close(IN);

my $data = join ('', @content);

my $out = join ("\t",
	'#',
	'title',
	'image',
	'title_en',
	'flavor',
	'neutral',
	'good1',
	'bad1',
	'good2title',
	'good2',
	'bad2title',
	'bad2',
	'final_effect'
	);
$out .= "\n";

my %card;
reset_card (\%card);
#print Dumper(\%card);


while ($data =~ s/(<td.+?)<\/td>//s) {
	my $td = $1;
	$card{bgcolor} = '';
	if ($td =~ /<td[^>]+bgcolor="#(\S{6})"[^>]+>/) {
		$card{bgcolor} = $1;
	}
	register_bgcolor(\%card, $td);
	#print "td=$card->{bgcolor}\n";
	while ($td =~ s/(<p.+?)<\/p>//s) {
		my $p = {font_size=>0};
		my $para = $1;
		if ($para =~ /align="([^"]+?)"/) {
			$p->{align} = $1;
		}
		if ($para =~ /<b>/) {
			$p->{bold} = 1;
		}
		if ($para =~ /<i>/) {
			$p->{italic} = 1;
		}
		if ($para =~ /style="font-size: (\d+)pt/) {
			$p->{font_size} = $1;
		}

		$para =~ s/<\/(p|font|i|span|b)>//sg;
		$para =~ s/<(p|font|i|span|b)[^>]*>//sg;
		$para =~ s/[\r\n]//sg;
		$para =~ s/\s+/ /sg;
		$para =~ s/^\s//s;
		$para =~ s/\s$//s;
		$para =~ s/“/"/sg;
		$para =~ s/”/"/sg;
		$para =~ s/«/"/sg;
		$para =~ s/»/"/sg;
		$para =~ s/’/'/sg;
		$p->{text} = $para;
		register_para (\%card, $p);
	}
	--$counter;
	#last if $counter <= 0;
	#die "Card:\n" . Dumper(\%card);
	#exit;
	#die $td;
}
$card{bgcolor} = '';
register_bgcolor(\%card);
open (OUT, ">$outfile.csv");
print (OUT $out);
close (OUT);
#`unoconv --format ods -i FilterOptions=9,,76 $outfile.csv`; 

sub reset_card {  # $card
	my $card = shift;
	$card->{mode} = 'start';
	$card->{bgcolor} = '';
	$card->{title} = '';
	$card->{flavor} = '';
	$card->{neutral} = '';
	$card->{good1} = '';
	$card->{bad1} = '';
	$card->{good2title} = '';
	$card->{good2} = '';
	$card->{bad2title} = '';
	$card->{bad2} = '';
	$card->{final_effect} = '';
}

sub print_card {  # $card
	my $card = shift;
	if ($card->{title} eq '') {
		return '';
	}
	warn "\nprint:\n" . Dumper($card);
	++$card_counter;
	my $result = join ("\t", (
		$card_counter,
		$card->{title},
		'',
		'',
		$card->{flavor},
		$card->{neutral},
		$card->{good1},
		$card->{bad1},
		$card->{good2title},
		$card->{good2},
		$card->{bad2title},
		$card->{bad2},
		$card->{final_effect}
		));
	#die "$result";
	return "$result\n";
}

sub register_bgcolor {  # $card
	my ($card, $td) = @_;
	$out .= print_card($card);
	reset_card($card);
}

sub register_para {  # $card, $p
	my ($card, $p) = @_;
	return if $p->{text} eq '';
	print "para:\n" . Dumper($p);
	if ($card->{mode} eq 'start') {
		if ($p->{bold}) {
			if ($p->{font_size} =~ /^[78]$/) {
				$p->{text} =~ s/([^\.])\.$/$1/;
				$card->{title} .= "$p->{text}|";
			}
			elsif ($p->{font_size} =~ /^6$/) {
				$card->{neutral} .= "$p->{text}|";
			}
			else {
				die "Unknown bold font_size $p->{font_size}!";
			}
		}
		elsif ($p->{italic}) {
			if ($p->{font_size} =~ /^[678]$/) {
				$card->{flavor} .= "$p->{text}|";
			}
			else {
				die "Unknown italic font_size $p->{font_size}!";
			}
		}
		else {
			$card->{neutral} .= "$p->{text}|";
		}
	}
	elsif ($card->{mode} =~ /good/) {
		if ($p->{bold}) {
			$card->{good2title} .= "$p->{text}|";
			$card->{mode} = 'good2';
		}
		else {
			if ($card->{mode} eq 'good2') {
				$card->{good2} .= "$p->{text}|";
			}
			else {
				$card->{good1} .= "$p->{text}|";
			}
		}
	}
	elsif ($card->{mode} =~ /bad/) {
		if ($p->{bold}) {
			$card->{bad2title} .= "$p->{text}|";
			$card->{mode} = 'bad2';
		}
		else {
			if ($card->{mode} eq 'bad2') {
				$card->{bad2} .= "$p->{text}|";
			}
			else {
				$card->{bad1} .= "$p->{text}|";
			}
		}
	}
	else {
		die "Unknown mode $card->{mode}!";
	}
}
