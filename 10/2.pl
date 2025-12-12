#!/usr/bin/perl -w

use 5.36.0;
use warnings;
no warnings 'recursion';
use strict;
use Memoize qw(memoize flush_cache);
use List::Util qw( min first );
use Data::Dumper;

memoize('dfs', NORMALIZER => 'normalize_dfs');
memoize('subtract_button', NORMALIZER => 'normalize_subtract_button');

my $total = 0;
while (<>) {
    chomp;
    say;
    my ($buttons, $joltages) = / (.*) \{(.*)\}$/;
    my @orig_joltages = split ',', $joltages;
    my @joltage_index = invert(
        map { $_->[0] }
        sort { $b->[1] <=> $a->[1] }
        map { [ $_, $orig_joltages[$_] ] } 0..$#orig_joltages);
    my @joltages = sort { $b <=> $a } @orig_joltages;
    #say "@orig_joltages";
    #say "@joltage_index";
    #say "@joltages";
    my @buttons =
                    map { button(\@joltage_index, split ',') }
                    map { $_ = substr $_, 1, -1; }
                    sort { length($b) <=> length($a) }
                    split ' ', $buttons;
    my $dim_buttons = dim_buttons(@buttons);
    say normalize_dfs(\@joltages, $dim_buttons);
#   die;
    #say map { "(@{$_->{original}})->(@{$_->{indices}}) [@{$_->{vector}}]  " } @buttons;
    my $count = dfs(\@joltages, $dim_buttons);
    flush_cache('dfs');
    $total += $count;
    say "$. $count $total";
}

say $total;

sub normalize_dfs {
    my ($joltages, $dim_buttons) = @_;
    my $s = "@$joltages";
    for my $buttons (@$dim_buttons) {
        $s .= "|";
        $s .= join ',', map { "@{$_->{indices}}" } @$buttons if $buttons; 
    }
    #say $s;
    return $s;
}

sub dfs {
    my ($joltages, $dim_buttons) = @_;
    
    pop @$joltages while @$joltages and $joltages->[-1] == 0;
    return 1 unless @$joltages;
    my $new_dim_buttons = @$dim_buttons > @$joltages ? [ @$dim_buttons[0..$#$joltages] ] : [ @$dim_buttons ];
    my $buttons = $new_dim_buttons->[$#$joltages];
    return 0 unless $buttons;
    my $min;

    for my $button (@$buttons) {
            my @new_joltages = subtract_button($joltages, 1, @{$button->{vector}});
            last unless @new_joltages;
            my $count = dfs(\@new_joltages, $new_dim_buttons);
            next unless defined $count;
            $count+=1;
            $min = $count unless defined $min and $count >= $min;
    }
    return $min;
}

sub dfs_buttons {
    my ($joltages, $i, $buttons) = @_;

    if ($i == @$buttons) {
        return 
    }
}


sub dim_buttons {
    my @buttons = @_;
    my @dim_buttons = ();
    push @{$dim_buttons[$_->{indices}->[-1]]}, $_ for @buttons;
    return \@dim_buttons;
}

sub button {
    my $joltage_index = shift;
    my @original = @_;
    my @indices = sort { $a <=> $b } map { $joltage_index->[$_] } @original;
    my @vector = (0) x @$joltage_index;
    $vector[$_] = 1 for @indices;
    return { indices => \@indices, vector => \@vector, original => \@original };
}

sub invert {
    my @input = @_;
    my @output = ();
    @output[$input[$_]] = $_ for 0..$#input;
    return @output;
}

sub subtract_button {
    my ($joltages, $mult, @vector) = @_;
    my @new_joltages = ();
    for (my $i = $#$joltages; $i >= 0; $i--) {
        my $new_joltage = $joltages->[$i] - $vector[$i]*$mult;
        return () if $new_joltage < 0;
        @new_joltages[$i] = $new_joltage;
    }
    return @new_joltages;
}

sub normalize_subtract_button {
    my ($joltages, @vector) = @_;
    return "@$joltages-@vector";
}