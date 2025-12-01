#!/usr/bin/perl -w

use 5.36.0;
use warnings;
use strict;

my $dial = 50;
my $password = 0;

while (<>) {
    my ($dir, $turn) = /([LR])(\d+)/ or die;
    $dial += ($dir eq 'L' ? -$turn : +$turn);
    $dial %= 100;
    say $dial;
    $password++ if $dial == 0;
}

say $password;