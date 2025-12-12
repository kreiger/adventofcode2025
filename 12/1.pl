#!/usr/bin/perl -w

use 5.36.0;
use warnings;
use strict;
use List::Util qw( sum );

local $/ = '';

my @shapes;
while (<>) {
    chomp;
    if (s/^(\d+):\n//) {
        my $index = $1;
        my $size = tr/#//;
        push @shapes, $size;
    } else {
        for (split "\n") {
            chomp;
            my ($w, $h, $sq) = /(\d+)x(\d+): (.*)/;
            my @sq = split ' ', $sq;
            say;
            say $w*$h;
            say sum map { $shapes[$_] * $sq[$_] } 0..$#sq;
        }
    }
}