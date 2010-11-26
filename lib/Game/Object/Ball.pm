package Game::Object::Ball;
use strict;
use warnings;
use Carp;

use SDLx::Controller::Interface;

sub new {
    my ( $class, $app, @args ) = @_;

    my $self = {};

    $self = bless( $self, $class );

    $self->interface = SDLx::Controller::Interface->new(@_);

    $self->_initialize();

    return $self;

}

sub interface : lvalue {
    $_[0]->{interface};
}

sub _initialize {
    my $self = shift;

    my $interface = $self->interface();

}

1;
