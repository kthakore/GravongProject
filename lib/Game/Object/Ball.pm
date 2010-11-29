package Game::Object::Ball;
use strict;
use warnings;
use Carp;
use SDLx::Controller::State;
use SDLx::Controller::Interface;

sub new {
    my $class = shift;
    my %args  = @_;

    my $self = \%args;

    $self = bless( $self, $class );

    $self->interface = SDLx::Controller::Interface->new(@_);

    $self->_initialize();

    return $self;

}

sub interface : lvalue {
    $_[0]->{interface};
}

sub _initialize {
    my ($self) = shift;

    my $app = $self->{app};

    my $interface = $self->interface;
    $interface->set_acceleration( sub { _acceleration( @_, $self, $app ) } );
    $interface->attach( $app, \&_show_ball, $app );

}

sub _acceleration {
    my ( $time, $current_state, $self, $app ) = @_;

    my $level = $self->{game}->{level};

    my $paddle = $self->{game}->{paddle};

    my $scores = $self->{game}->{scores};

    if ( $current_state->y > $app->h ) {
        $scores->[0] -= 1;

        $self->{updated_score} = 1;

        _reset_ball( $app->w, $app->h, $current_state );
    }

    my $sum_accel_x = 0;
    my $sum_accel_y = 0;

    my @planets = @{$level};
    foreach my $planet (@planets) {

        my $dx = ( $planet->{x} - $current_state->x );
        my $dy = ( $planet->{y} - $current_state->y );
        my $D  = sqrt( $dx**2 + $dy**2 );

        if ( $D < 1 ) { $D = 1 }

        my $A = 4000 * $planet->{size} / $D**2;

        if ( $D < ( $planet->{size} + 5 ) ) {
            $sum_accel_x -= ( $dx * $A / $D ) * 0.4;
            $sum_accel_y -= ( $dy * $A / $D ) * 0.4;
        }
        else {
            $sum_accel_x += $dx * $A / $D;
            $sum_accel_y += $dy * $A / $D;
        }

    }

    if (
        _collision(
            $current_state->x - 5, $current_state->y - 5,
            10,                    10,
            $paddle->{x},          $paddle->{y},
            $paddle->{w},          $paddle->{h}
        )
      )
    {
        $current_state->v_y( -$current_state->v_y );
        $current_state->y( $current_state->y + ( 0.4 * $current_state->v_y ) );
    }

    if ( $current_state->x < 0 || $current_state->x > $app->w ) {
        $current_state->v_x( -$current_state->v_x );
    }
    if ( $current_state->x < 0 ) { $current_state->x(0) }
    $current_state->x( $app->w ) if $current_state->x > $app->w;

    if ( $current_state->y < 0 || $current_state->y > $app->h ) {
        $current_state->v_y( -$current_state->v_y );
    }

    $current_state->y(0) if $current_state->y < 0;
    $current_state->y( $app->h ) if $current_state->y > $app->h;

    if ( abs( $current_state->v_x() ) > 200 ) {
        $current_state->v_x(200);
    }
    if ( abs( $current_state->v_y() ) > 200 ) {
        $current_state->v_y(200);
    }
    return ( $sum_accel_x, $sum_accel_y, 0 );
}

sub _reset_ball {
    my ( $w, $h, $state ) = @_;

    my $x = rand($w);
    my $y = rand($h);

    my $mrs = 50;
    my $v_x = rand($mrs) - rand($mrs) + $mrs / 2;
    my $v_y = rand($mrs) - rand($mrs) + $mrs / 2;

    $state->x($x);
    $state->y($y);
    $state->v_x($v_x);
    $state->v_y($v_y);

}

sub _show_ball {
    my $state = shift;
    my $app   = shift;

    $app->draw_circle_filled( [ $state->x, $state->y ],
        5, [ 0, 255, 0, 255 ], 1 );
}

sub _collision {
    my ( $x1, $y1, $w1, $h1, $x2, $y2, $w2, $h2 ) = @_;

    my ( $l1, $l2, $r1, $r2, $t1, $t2, $b1, $b2 );

    $l1 = $x1;
    $l2 = $x2;
    $r1 = $x1 + $w1;
    $r2 = $x2 + $w2;
    $t1 = $y1;
    $t2 = $y2;
    $b1 = $y1 + $h1, $b2 = $y2 + $h2;

    return 0 if ( $b1 < $t2 );
    return 0 if ( $t1 > $b2 );
    return 0 if ( $r1 < $l2 );
    return 0 if ( $l1 > $r2 );
    return 1;

}

1;
