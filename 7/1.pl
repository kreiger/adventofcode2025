#!/usr/bin/perl -w

use 5.36.0;
use warnings;
use strict;
use bigint;

use List::Util qw( zip sum product );

my $total = 0;
$_ = <>;
chomp;
my @current = map { $_ eq '.' ? 0 : 1 } split '';
while (<>) {
    chomp;
    next unless /[^.]/;
    my @row = map { $_ eq '.' ? 0 : 1 } split '';
    my @new = @current;
    for (my $i = 0; $i < @row; $i++) {
        if ($row[$i] & $current[$i]) {
            $total++;
            $new[$i-1] = 1;
            $new[$i]   = 0;
            $new[$i+1] = 1;
        } else {
            $new[$i] = $new[$i] | $current[$i];
        }
    }
    @current = @new;
}

say $total;
