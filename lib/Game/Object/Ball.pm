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

    my $app = $self->{app};


    my $interface = $self->interface;
    $interface->set_acceleration( sub { _acceleration( @_, $self->{level}, $app ) } );
    $interface->attach( $app, \&_show_ball, $app );

}


sub _acceleration {
    my ( $time, $current_state, $level, $app ) = @_;

	my $sum_accel_x = 0;
	my $sum_accel_y = 0;

	 my @planets = @{ $level };

	foreach my $planet ( @planets )
	{
		my $dx = ($planet->{x} - $current_state->x);
		my $dy = ($planet->{y} -  $current_state->y);
		my $D = sqrt( $dx**2 + $dy**2);
		my $A = 7200 * $planet->{size} / $D ** 2 ;

		if ($D < ($planet->{size} + 5 ) ) 
		{
			
			
			$sum_accel_x -= ($dx * $A/$D )*0.4;
			$sum_accel_y -= ($dy * $A/$D )*0.4;

		}
		else
		{
			$sum_accel_x += $dx * $A/$D;
			$sum_accel_y += $dy * $A/$D;
		}

	}


	if ( $current_state->x < 0 || $current_state->x > $app->w ) { $current_state->v_x( -$current_state->v_x ) };
	if( $current_state->x < 0 ) { $current_state->x(0) }
	$current_state->x( $app->w ) if $current_state->x > $app->w;

	if ( $current_state->y < 0 || $current_state->y > $app->h ) { $current_state->v_y( -$current_state->v_y ) };

	 $current_state->y(0) if $current_state->y < 0;
	  $current_state->y( $app->h ) if $current_state->y > $app->h; 

    return ( $sum_accel_x, $sum_accel_y  , 0 );
}

sub _show_ball {
    my $state = shift;
    my $app   = shift;

    $app->draw_circle_filled( [ $state->x, $state->y ],
        5, [ 0, 255, 0, 255 ], 1 );
}

1;
