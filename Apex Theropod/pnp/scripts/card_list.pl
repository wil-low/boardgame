#!/usr/bin/perl

use strict;
use warnings;
use JSON;
use Data::Dumper;

my @tts_images = (
	['httpiimgurcom6nJuIw2jpg.jpg', 1, 70],
	['httpiimgurcomhBvoqQKjpg.jpg', 2, 70],
	['httpiimgurcomoBnJoo6jpg.jpg', 3, 36],
	['httpiimgurcomPk3tA8ujpg.jpg', 4, 2],
	['httpiimgurcomsRZWuRKjpg.jpg', 5, 70],
	['httpiimgurcomV5r4dKkjpg.jpg', 6, 59],
	['httpiimgurcomyBH0Kzmjpg.jpg', 7, 41],
);


my %tts_map;

for my $tts (@tts_images) {
	$tts_map{$tts->[0]} = $tts->[1];
}

my %csv_files = (
	multi => ['Afflictions','Stomping Dead - Afflcition Deck', 'Stomping Dead - Environment Cards', 'Stomping Dead - Infected Deck'],
	Acrocanthosaurus => ['Apex - Acrocanthosaurus'],
	Carcharodon => ['Apex - Carcharodon'],
	Carnotaurus => ['Apex - Carnotaurus'],
	Giganotosaurus => ['Apex - Giganotosaurus'],
	Promethean => ['Apex - Promethean Wars'],
	Saurophaganax => ['Apex - Saurophaganax'],
	Spinosaurus => ['Apex - Spinosaurus'],
	Suchomimus => ['Apex - Suchomimus'],
	Therizinosaurus => ['Apex - Therizinosaurus'],
	Tyrannosaurus => ['Apex - Tyrannosaurus'],
	Utahraptor => ['Apex - Utahraptor'],
	Velociraptor => ['Apex - Velociraptor'],
	other => [
		'Alert',
		'Boss',
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
	],
);


my %deck_map;

for my $key (keys (%csv_files)) {
	for my $key2 (@{$csv_files{$key}}) {
		$deck_map{$key2} = $key;
	}
}

open (JSON, "<../../tts/680447815.json");
my @data = <JSON>;
close (JSON);

my %decks;
my %cards;

my $json = decode_json (join ('', @data));
my $var = $json->{ObjectStates};

for my $deck (@{$json->{ObjectStates}}) {
	if (defined ($deck->{Name}) and $deck->{Name} eq 'Deck') {
		my $nick = $deck->{Nickname};
		$decks{$nick}->{Cards} = $deck->{DeckIDs};
		my $custom = $deck->{CustomDeck};
		for my $key (keys (%$custom)) {
			my $url = $custom->{$key}->{FaceURL};
			$url =~ s/\W//g;
			$decks{$nick}->{tiles}->{$key} = $tts_map{"$url.jpg"};

		}
		my $contained = $deck->{ContainedObjects};
		for my $card (@$contained) {
			if (defined ($card->{Name}) and $card->{Name} eq 'Card') {
				my $id = $card->{CardID};
				if (!defined ($cards{$id})) {
					$cards{$id} = {nick => $card->{Nickname}, desc => $card->{Description}};
				}
			}
		}
	}
}

my %csv_data;

for my $key (keys (%decks)) {
	my $deck = $decks{$key};
	my $csv_filename = $deck_map{$key};
	die $key if !defined $csv_filename;
	if (!defined ($csv_data{$csv_filename})) {
		$csv_data{$csv_filename} = [];
	}
	for my $card (@{$deck->{Cards}}) {
		$card =~ /(\d+)(\d\d)$/;
		my ($tile, $num) = ($1, $2);
		push (@{$csv_data{$csv_filename}}, '../img/sheet' . $deck->{tiles}->{$tile} . '-' . $num . ".png");
	}
}

for my $key (keys (%csv_data)) {
	open (CSV, ">../csv/$key.csv");
	my $counter = 0;
	for my $card (@{$csv_data{$key}}) {
		print CSV "$card\n";
		++$counter;
	}
	my $remainder = 9 - ($counter % 9);
	for (my $i = 0; $i < $remainder; ++$i) {
		print CSV "../blank.png\n";
	}
	close (CSV);
}
#print Dumper(\%decks);
#print Dumper(\%cards);