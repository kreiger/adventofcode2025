#!/usr/bin/perl -w

use 5.36.0;
use warnings;
use strict;

my @matrix = ();
while (<>) {
    chomp;
    my @line = map { $_ eq '@' ? 1 : 0 } split '';
    push @matrix, \@line;
}

my $width = scalar @{$matrix[0]};
my $height = scalar @matrix;

say "$width x $height";
#exit 1;


my $total = 0;
my @neighbors = ();
while (1) {
    my $removed = 0;
    my @h = ();
    for (my $y = 0; $y < $height; ++$y) {
        my $prev = 0;
        for (my $x = 0; $x < $width; ++$x) {
            $h[$y][$x] = $prev + $matrix[$y][$x] + ($matrix[$y][$x + 1] || 0);
            $prev = $matrix[$y][$x];
        }
    }

    for (my $x = 0; $x < $width; ++$x) {
        my $prev = 0;
        for (my $y = 0; $y < $height; ++$y) {
            my $neighbors = $prev + $h[$y][$x] + ($h[$y+1][$x] || 0) - $matrix[$y][$x];
            $neighbors[$y][$x] = $neighbors;
            $prev = $h[$y][$x];

            if ($matrix[$y][$x] and $neighbors < 4) {
                ++$total;
                $matrix[$y][$x] = 0;
                $removed++;
            }
        }
    }
    last unless $removed;
}

say @{$_} for @matrix;
print "\n";

say @{$_} for @neighbors;
print "\n";

say $total;