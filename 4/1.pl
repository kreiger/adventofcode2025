#!/usr/bin/perl -w

use 5.36.0;
use warnings;
use strict;

my @matrix = ();
my @h = ();
while (<>) {
    chomp;
    my @line = map { $_ eq '@' ? 1 : 0 } split '';
    push @matrix, \@line;
    my @hline = ();
    my $prev = 0;
    for (my $x = 0; $x < @line; ++$x) {
        $hline[$x] = $prev + $line[$x] + ($line[$x + 1] || 0);
        $prev = $line[$x];
    }
    push @h, \@hline;
}

my @neighbors = ();

my $width = @{$h[0]};
my $height = scalar @h;

my $total = 0;
for (my $x = 0; $x < $width; ++$x) {
    my $prev = 0;
    for (my $y = 0; $y < $height; ++$y) {
        my $neighbors = $prev + $h[$y][$x] + ($h[$y+1][$x] || 0) - $matrix[$y][$x];
        $neighbors[$y][$x] = $neighbors;
        $prev = $h[$y][$x];

        ++$total if $matrix[$y][$x] and $neighbors < 4;
    }
}

say @{$_} for @matrix;
print "\n";
say @{$_} for @h;
print "\n";
say @{$_} for @neighbors;
print "\n";

say $total;