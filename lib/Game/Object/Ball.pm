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

	$interface->attach( $app, \&_show_ball,  $app );

}

sub _acceleration {
    my ( $time, $current_state, $level ) = @_;


	return (0,1,0);
}

sub _show_ball {
              my $state = shift;
			  my $app = shift;

			
			$app->draw_circle_filled( [$state->x, $state->y], 5, [0,255,0,255], 1 );
}

1;
