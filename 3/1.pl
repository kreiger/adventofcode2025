#!/usr/bin/perl -w

use 5.36.0;
use warnings;
use strict;


my $total = 0;
while (<>) {
    my @digits = split '';
    my $max = 0;
    for (my $i = 0; $i < @digits - 1; ++$i) {
        for (my $j = $i + 1; $j < @digits; ++$j) {
            my $joltage = "$digits[$i]$digits[$j]";
            $max = $joltage if $joltage > $max;
        }
    }
    $total += $max;
}

say $total;


