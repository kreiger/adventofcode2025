#!/usr/bin/perl -w

use 5.36.0;
use warnings;
use strict;

local $/ = ',';
my $total = 0;

while (<>) {
    chomp;
    my ($min, $max) = /(\d+)-(\d+)/ or die;
    for ($min..$max) {
        $total += $_ if /^(\d+)\1+$/ 
    }
}

say $total;
