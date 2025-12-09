package Rectangle;

use strict;
use warnings;
#use Carp::Always;
use Exporter 'import';
use lib '.';
use Vector2D;
use List::Util qw( min max );

use overload
    '""' => sub { my $r = shift; "$r->[0] $r->[1]" }
;

sub new {
    my $class = shift;
    my ($v, $w) = @_;

    my $min_x = min($v->x, $w->x);
    my $max_x = max($v->x, $w->x);
    my $min_y = min($v->y, $w->y);
    my $max_y = max($v->y, $w->y);

    my $width = $max_x - $min_x + 1;
    my $height = $max_y - $min_y + 1;
    my $area = $width*$height;

    my $self = bless [V($min_x,$min_y),V($max_x, $max_y), $area], $class;
    return $self;
}

sub empty {
    my $class = shift;

    my $self = bless [V(0,0),V(0,0), 0], $class;
    return $self;
}

sub area {
    my $self = shift;
    return $self->[2];
}

sub left {
    my $self = shift;
    return $self->[0]->x;
}

sub right {
    my $self = shift;
    return $self->[1]->x;
}

sub top {
    my $self = shift;
    return $self->[0]->y;
}

sub bottom {
    my $self = shift;
    return $self->[1]->y;
}


sub contains {
    my $r = shift;
    my $v = shift;
    return 
        $v->x >= $r->left  &&
        $v->x <= $r->right &&
        $v->y >= $r->top   &&
        $v->y <= $r->bottom ;
}

sub inside {
    my $r = shift;
    my $v = shift;
    return 
        $v->x > $r->left  &&
        $v->x < $r->right &&
        $v->y > $r->top   &&
        $v->y < $r->bottom ;
}

sub overlap {
    my $self = shift;
    my $r = shift;

    return
        $self->left < $r->right &&
        $self->right > $r->left &&
        $self->top < $r->bottom &&
        $self->bottom > $r->top ;
}

1;
