#!/usr/bin/perl -w

use 5.36.0;
use warnings;
use strict;
use Memoize;
use List::Util qw( min );

memoize('dfs', NORMALIZER => 'normalize');
memoize('subtract_button', NORMALIZER => 'normalize_subtract_button');

my $total = 0;
while (<>) {
    chomp;
    say;
    my ($buttons, $joltages) = / (.*) \{(.*)\}$/;
    my @joltages = split ',', $joltages;
    my @buttons = map { $_ = substr $_, 1, -1; my @button = (0) x @joltages; @button[$_] = 1 for split ','; \@button } sort { length($b) <=> length($a) } split ' ', $buttons;

    my $count = dfs(\@joltages, \@buttons);
    $total += $count;
    say "$. $count $total";
}

say $total;

sub dfs {
    my ($joltages, $buttons) = @_;
    my @queue = ();
    for my $button (@$buttons) {
        my ($found, @new_joltages) = subtract_button($joltages, $button);
#        say "@$joltages | @$button | $found | @new_joltages";
        next if -1 == $found;
        return 1 if $found;
        push @queue, \@new_joltages;
    }
    my $min;
    for my $new_joltages (@queue) {
        my $count = dfs($new_joltages, $buttons);
        next unless defined $count;
        $count++;
        $min = $count unless defined $min and $count >= $min;
    }
    return $min;
}

sub subtract_button {
    my ($joltages, $button) = @_;
    my @new_joltages = ();
    my $found = 1;
    for (my $i = 0; $i < @$joltages; $i++) {
        my $new_joltage = $joltages->[$i] - $button->[$i];
        return -1 if $new_joltage < 0;
        $found = 0 if $new_joltage > 0;
        @new_joltages[$i] = $new_joltage;
    }
    return $found, @new_joltages;
}

sub normalize {
    my ($joltages, $buttons) = @_;
    return "@$joltages|".join '|',map { "@$_" } @$buttons;
}

sub normalize_subtract_button {
    my ($joltages, $button) = @_;
    return "@$joltages|@$button";
}