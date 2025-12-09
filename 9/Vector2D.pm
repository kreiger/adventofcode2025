package Vector2D;

use strict;
use warnings;
#use Carp::Always;
use Exporter 'import';
our @EXPORT = qw( V );

use overload 
    '+'  => \&add,
    '-' =>  \&subtract,
    '*' =>  \&multiply,
    '%' =>  \&mod,
    'neg' => sub { subtract(V(0,0), shift); } ,
    '==' => \&eq,
    '""' => sub { my $v = shift; "($v->[0] $v->[1])" }
;


sub new {
    my $class = shift;
    my ($x, $y) = @_;

    my $self = bless [$x,$y], $class;

    return $self;
}

sub V {
    my ($x, $y) = @_;
    return Vector2D->new($x, $y);
}

sub x {
    my $v = shift;
    return $v->[0];
}

sub y {
    my $v = shift;
    return $v->[1];
}

sub add {
    my ($v, $w) = @_;
    return V($v->[0] + $w->[0], $v->[1] + $w->[1]);
}

sub subtract {
    my $v = shift;
    my $w = shift;
    return V($v->[0] - $w->[0], $v->[1] - $w->[1]);
}

sub multiply {
    my $v = shift;
    my $s = shift;
    return V($v->[0] * $s, $v->[1] * $s);    
}

sub mod {
    my ($v, $w) = @_;
    return V($v->[0] % $w->[0], $v->[1] % $w->[1]);
}

sub eq {
    my $v = shift;
    my $w = shift;
    return $v->[0] == $w->[0] && $v->[1] == $w->[1];
}

sub left {
    my $v = shift;
    return V($v->y, -$v->x);
}

sub right {
    my $v = shift;
    return V(-$v->y, $v->x);
}

sub char {
    my $v = shift;
    return '^' if $v == V( 0, -1);
    return '>' if $v == V( 1,  0);
    return 'v' if $v == V( 0,  1);
    return '<' if $v == V(-1,  0);
}

sub manhattan {
    my $v = shift;
    return abs($v->x) + abs($v->y);
}

sub cross {
    my $v = shift;
    my $w = shift;
    return $v->x * $w->y - $v->y * $w->x;
}

sub sign {
    my $v = shift;
    return V($v->x <=> 0, $v->y <=> 0);
}

1;
