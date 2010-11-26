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
    my ($self) = @_;

    my $interface = $self->interface;
    $interface->set_acceleration( sub { _acceleration( @_, $self->{level} ) } );

    my $app = $self->{app};

    $interface->attach( $app, \&_show_ball, $app );

}

sub _gravity {
	my ($x1, $x2, $size) = @_;

	my $dist_square =  ($x1 - $x2 );

	return ($size * 6)/ $dist_square ;

}

sub _acceleration {
    my ( $time, $current_state, $level ) = @_;

	my $sum_accel_x = 0;
	my $sum_accel_y = 0;

	 my @planets = @{ $level };

	foreach my $planet ( @planets )
	{
		
		$sum_accel_x += _gravity( $current_state->x, $planet->{x}, $planet->{size} );
		$sum_accel_y += _gravity( $current_state->y, $planet->{y}, $planet->{size} );


	}
    return ( $sum_accel_x, -$sum_accel_y , 0 );
}

sub _show_ball {
    my $state = shift;
    my $app   = shift;

    $app->draw_circle_filled( [ $state->x, $state->y ],
        5, [ 0, 255, 0, 255 ], 1 );
}

1;
