#!/usr/bin/perl -w

use 5.36.0;
use warnings;
use strict;

use List::Util qw( any );

my $total = 0;
my @ranges = ();
while (<>) {
    if (/(\d+)-(\d+)/) {
        push @ranges, { min => $1, max => $2 };
        next;
    }
    next unless my ($id) = /(\d+)/;
    my $fresh = grep { $_->{min} <= $id && $id <= $_->{max} } @ranges;
    $total++ if $fresh;
}

say $total;


