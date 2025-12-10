#!/usr/bin/perl

use 5.36.0;
use strict;
use warnings;

my $max = 1 << 13;

my $bits
    map { $_->[0] }
    sort { $a->[1] <=> $b->[1] }
    map { [ $_, count_bits_set($_) ] } 
    (0 .. ($max - 1));

sub count_bits_set {
    my $bits = shift;
    my $count = 0;
    while ($bits) {
        $count++ if $bits & 1;
        $bits >>= 1;
    }
    return $count;
}