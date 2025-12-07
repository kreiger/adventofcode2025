#!/usr/bin/perl -w

use 5.36.0;
use warnings;
use strict;
use bigint;
use Memoize;
use List::Util qw( zip sum product );

memoize('count_timelines');

my $total = 0;
$_ = <>;
chomp;
my $beam = index($_, 'S');
my @rows = ();
while (<>) {
    next unless /\^/;
    chomp;
    push @rows, [ map { $_ eq '.' ? 0 : 1 } split '' ]
}

sub count_timelines {
    my ($beam, $row) = @_;
    return 1 if $row >= @rows;
    if ($rows[$row]->[$beam]) {
        return count_timelines($beam-1,$row+1) + count_timelines($beam+1,$row+1);
    }
    return count_timelines($beam, $row+1);
}

say count_timelines($beam,0);
