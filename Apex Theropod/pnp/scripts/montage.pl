#!/usr/bin/perl

use strict;
use warnings;
use JSON;
use Data::Dumper;

my @csv_files = (
#	'Afflictions',
#	'Alert',
#	'Apex - Acrocanthosaurus',
	'Apex - Carcharodon',
	'Apex - Carnotaurus',
	'Apex - Giganotosaurus',
	'Apex - Promethean Wars',
	'Apex - Saurophaganax',
	'Apex - Spinosaurus',
	'Apex - Suchomimus',
	'Apex - Therizinosaurus',
	'Apex - Tyrannosaurus',
	'Apex - Utahraptor',
	'Apex - Velociraptor',
#	'Boss',
	'Defensive Stance & Disaster Area',
	'Environment',
	'Evolve',
	'Hunt - Big Game',
	'Hunt - Menace',
	'Hunt - Minion',
	'Hunt - Predator',
	'Hunt - Prey',
	'Hunt - Titan',
	'Solo Afflictions',
	'Starting Deck',
	'Stomping Dead - Afflcition Deck',
	'Stomping Dead - Environment Cards',
);

if (defined ($ARGV[0])) {
	@csv_files = ($ARGV[0]);
}

for (@csv_files) {
	montage ($_);
}

sub montage {
	my ($csv) = @_;
	mkdir ("../3x3/$csv");
	`rm '../3x3/$csv/*.png'`;
	`gm montage \@'../csv/$csv.csv' -monitor +adjoin -tile 3x3 -geometry +0+0 '../3x3/$csv/%02d.png'`;
}
#print Dumper(\%decks);
#print Dumper(\%cards);