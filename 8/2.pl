#!/usr/bin/perl -w

use 5.36.0;
use warnings;
use strict;
use Data::Dumper;
use List::Util qw( product );

my @boxes = ();
while (<>) {
    chomp;
    my ($x, $y, $z) = /(\d+),(\d+),(\d+)/ or die;
    push @boxes, { id => $_, x => $x, y => $y, z => $z };
}

my %distances = ();
my @distances = ();
my @connections = ();
for (my $i = 0; $i < @boxes; $i++)  {
    for (my $j = $i+1; $j < @boxes; $j++) {
        my $a = $boxes[$i];
        my $b = $boxes[$j];
        my $d = distance($a, $b);
        my $connection = { d => $d, a => $a->{id}, b => $b->{id} };
        push @connections, $connection;
    }
}

@connections = sort { $a->{d} <=> $b->{d} } @connections;

my @circuits = map { { boxes => [ $_->{id} ] } } @boxes;
my %circuits = map { ( $_->{boxes}[0] => $_ ) } @circuits;
for my $con (@connections) {
    my $a = $con->{a};
    my $b = $con->{b};
    my $circ_a = $circuits{$a};
    my $circ_b = $circuits{$b};
    next if $circ_a == $circ_b;
    push @{$circ_a->{boxes}}, @{$circ_b->{boxes}};
    $circuits{$_} = $circ_a for @{$circ_b->{boxes}};
    $circ_b->{boxes} = [];
    if (@boxes == @{$circ_a->{boxes}}) {
        $a =~ s/,.*//;
        $b =~ s/,.*//;
        say $a * $b;
        exit 0;
    }
}

die;

sub distance {
    my ($v, $w) = @_;
    my $dx = $v->{x} - $w->{x};
    my $dy = $v->{y} - $w->{y};
    my $dz = $v->{z} - $w->{z};
    return sqrt($dx*$dx + $dy*$dy + $dz*$dz);
}