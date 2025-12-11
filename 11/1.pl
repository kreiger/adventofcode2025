#!/usr/bin/perl

use 5.36.0;
use warnings;
use strict;
use List::Util qw( sum );


my %devices = ();

while (<>) {
    chomp;
    my ($from, $to) = /(\w+): (.*)/;
    $devices{$from} = [ split ' ', $to ];

}

say dfs('you');


sub dfs {
    my $from = shift;
    return 1 if $from eq 'out';
    sum map { dfs($_) } @{$devices{$from}};
}