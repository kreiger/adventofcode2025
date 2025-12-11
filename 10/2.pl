#!/usr/bin/perl -w

use 5.36.0;
use warnings;
use strict;
use Memoize;
use List::Util qw( min first );
use Data::Dumper;

#memoize('dfs', NORMALIZER => 'normalize');
#memoize('subtract_button', NORMALIZER => 'normalize_subtract_button');

my $total = 0;
while (<>) {
    chomp;
    say;
    my ($buttons, $joltages) = / (.*) \{(.*)\}$/;
    my @joltages = split ',', $joltages;
    my @joltage_index = 
        map { $_->[0] }
        sort { $b->[1] <=> $a->[1] }
        map { [ $_, $joltages[$_] ] } 0..$#joltages;
    my %joltage_index = map { $joltage_index[$_] => $_ } 0..$#joltages;
    #say Dumper(\%joltage_index);
    @joltages = sort { $b <=> $a } @joltages;
    say "@joltages";
    my @buttons =
                    map { my @indices = map {$joltage_index{$_}} split ','; button(scalar @joltages, @indices) }
                    map { $_ = substr $_, 1, -1; }
                    sort { length($b) <=> length($a) } split ' ', $buttons;
    my $dim_buttons = dim_buttons(@buttons);
    say map { "@{$_->{indices}}  " } @buttons;
    #die;
    #my $count = dfs(\@joltages, $dim_buttons);
    #$total += $count;
    #say "$. $count $total";
}

say $total;

sub dfs {
    my ($joltages, $dim_buttons) = @_;
    
    pop @$joltages while @$joltages and $joltages->[-1] == 0;
    pop @$dim_buttons while @$dim_buttons > @$joltages;

    return 1 unless @$joltages;
    my $buttons = $dim_buttons->[$#$joltages];
    die unless $buttons;
    my $min;
    for my $button (@$buttons) {
        my ($zeroes, @new_joltages) = subtract_button($joltages, $button);
        next unless defined $zeroes;
        return 1 if $zeroes == @$joltages;
        my $count = dfs($joltages, $dim_buttons);
        next unless defined $count;
        $count++;
        $min = $count unless defined $min and $count >= $min;
    }
    return $min;

}

sub dim_buttons {
    my @buttons = @_;
    my @dim_buttons = ();
    push @{$dim_buttons[$_->{indices}->[-1]]}, $_ for @buttons;
    return \@dim_buttons;
}

sub button {
    my $length = shift;
    my @indices = sort { $a <=> $b } @_;
    my @vector = (0) x $length;
    $vector[$_] = 1 for @indices;
    return { indices => \@indices, vector => \@vector };
}

sub subtract_button {
    my ($joltages, $button) = @_;
    my @new_joltages = ();
    my @zeroes = ();
    for (my $i = 0; $i < @$joltages; $i++) {
        my $new_joltage = $joltages->[$i] - $button->{indices}->[$i];
        return undef if $new_joltage < 0;
        push @zeroes, $i if $new_joltage == 0;
        @new_joltages[$i] = $new_joltage;
    }
    return \@zeroes, @new_joltages;
}
