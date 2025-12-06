#!/usr/bin/perl -w

use 5.36.0;
use warnings;
use strict;

use List::Util qw( zip sum product );

my $total = 0;
my @rows = ();
while (<>) {
    push @rows, [ split ];
}

my @problems = zip @rows;

for my $problem (@problems) {
    my $op = pop @{$problem};
    if ($op eq '+') {
        $total += sum @{$problem};
    } else {
        $total += product @{$problem};
    }
}

say $total;


