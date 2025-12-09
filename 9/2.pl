#!/usr/bin/perl -w

use 5.36.0;
use warnings;
use strict;
use List::Util qw( any );
use lib '.';
use Vector2D;
use Rectangle;

my @tiles = ();
while (<>) {
    chomp;
    my ($x, $y) = /(\d+),(\d+)/;
    push @tiles, { pos => V($x,$y) };
}

my @avoid_edges = ();
for (my $i = -1; $i < @tiles - 1; $i++) {
    my ($u, $v, $w) = ($tiles[$i-1]->{pos}, $tiles[$i]->{pos}, $tiles[$i+1]->{pos});
    my $edge_a = $v - $u;
    my $edge_b = $w - $v;
    my $s = $edge_b->sign;
    my $avoid_a = $v + $s + $s->left;
    my $avoid_b = $w - $s + $s->left;
    push @avoid_edges, Rectangle->new($avoid_a, $avoid_b);
}

@avoid_edges = sort { $b->area <=> $a->area } @avoid_edges;

my @rectangles = ();
for (my $i = 0; $i < @tiles; $i++) {
    for (my $j = $i + 1; $j < @tiles; $j++) {
        my $rectangle = Rectangle->new($tiles[$i]->{pos}, $tiles[$j]->{pos});
        push @rectangles, $rectangle;
    }
}

@rectangles = sort { $b->area <=> $a->area } @rectangles;

for my $rectangle (@rectangles) {
    next if any { $rectangle->overlap($_) } @avoid_edges;
    say $rectangle->area;
    exit 0;
}

