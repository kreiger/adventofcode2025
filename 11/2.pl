#!/usr/bin/perl

use 5.36.0;
use warnings;
use strict;
use List::Util qw( sum );
use Memoize;

memoize('dfs');

my %devices = ();

while (<>) {
    chomp;
    my ($from, $to) = /(\w+): (.*)/;
    $devices{$from} = [ split ' ', $to ];

}

say dfs('svr', 0);


sub dfs {
    my ($from, $found) = @_;
    return ($found == 3 ? 1 : 0) if $from eq 'out';
    $found |= 1 if $from eq 'dac';
    $found |= 2 if $from eq 'fft';
    sum map { dfs($_, $found) } @{$devices{$from}};
}
