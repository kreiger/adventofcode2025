#!/usr/bin/perl -w

use 5.36.0;
use warnings;
use strict;

my @tiles = ();
while (<>) {
    chomp;
    my ($x, $y) = /(\d+),(\d+)/;
    push @tiles, { x => $x, y => $y };
}

my $max_area = 0;
for (my $i = 0; $i < @tiles; $i++) {
    for (my $j = $i + 1; $j < @tiles; $j++) {
        my $area = area($tiles[$i], $tiles[$j]);
        $max_area = $area if $area > $max_area;
    }
}

say $max_area;

sub area {
    my ($a, $b) = @_;
    my $w = abs($a->{x} - $b->{x}) + 1;
    my $h = abs($a->{y} - $b->{y}) + 1;
    return $w*$h;
}