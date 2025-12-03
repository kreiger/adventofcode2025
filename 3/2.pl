#!/usr/bin/perl -w

use 5.36.0;
use warnings;
use strict;
use List::Util qw(max);
use Memoize;

memoize('max_joltage');

my $total = 0;
while (<>) {
    chomp;
    my @digits = split '';
    my $max = max_joltage(12, @digits);
    say $max;
    $total += $max;
}

say $total;

sub max_joltage {
    my ($count, @digits) = @_;

    die if @digits < $count;
    return max(@digits) if $count == 1;

    my $max_digit = 0;
    my $max = 0;
    while ($count <= @digits) {
        my $digit = shift @digits;
        next unless $digit > $max_digit;
        $max_digit = $digit;
        my $joltage = $digit.max_joltage($count-1, @digits);
        $max = $joltage if $joltage > $max;
    }
    return $max;
}

