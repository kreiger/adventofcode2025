#!/usr/bin/perl -w

use 5.36.0;
use warnings;
use strict;

use List::Util qw( zip sum product );

my $total = 0;
my @rows = ();
my $ops;
while (<>) {
    if (/\d/) {
        push @rows, $_;
        next;
    }
    while (/(([+*])\s+)/g) {
        my ($all, $op) = ($1, $2);
        my $length = length $all;
        my @numbers = map { split }
                      map { join '', @{$_} }
                      zip
                      map { [ split '' ] }
                      map { substr $_, 0, $length, '' }
                      @rows;
        if ($op eq '+') {
            $total += sum @numbers;
        } else {
            $total += product @numbers;
        }
    }
}

say $total;


