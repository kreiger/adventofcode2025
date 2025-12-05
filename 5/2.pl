#!/usr/bin/perl -w

use 5.36.0;
use warnings;
use strict;

use List::Util qw( first sum );

my @ranges = ();
while (<>) {
    next unless /(\d+)-(\d+)/;
    my ($min, $max) = ($1, $2);
    my @overlap = ();
    my @nonoverlap = ();
    for (@ranges) {
        my $overlap = ($_->{max} >= ($min - 1)) && ($_->{min} <= ($max + 1)) ? 1 : 0;
        if ($overlap) {
            push @overlap, $_;
        } else {
            push @nonoverlap, $_;
        }
    }
    if (@overlap) {
        for (@overlap) {
            $min = $_->{min} if $_->{min} < $min;
            $max = $_->{max} if $_->{max} > $max;
        }
        @ranges = @nonoverlap;
    }
    my $range = { min => $min, max => $max };
    push @ranges, $range;
}
say "$_->{min}-$_->{max}" for @ranges;
my $total = sum map { $_->{max} - $_->{min} + 1} @ranges;

say $total;
