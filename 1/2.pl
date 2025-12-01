#!/usr/bin/perl -w

use 5.36.0;
use warnings;
use strict;

my $dial = 50;
my $password = 0;

while (<>) {
    my ($dir, $turn) = /([LR])(\d+)/ or die;
    my $click = ($dir eq 'L' ? -1 : +1);
    while ($turn--) {
        $dial += $click;
        $dial %= 100;
        $password++ if $dial == 0;
    }
}

say $password;