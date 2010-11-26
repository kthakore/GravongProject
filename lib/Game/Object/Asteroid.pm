package Game::Object::Asteroid;
use strict;
use warnings;
use Carp;

sub new {
    my ( $class, @args ) = @_;

    my $self = {};

    $self = bless( $self, $class );

    return $self;

}

1;
