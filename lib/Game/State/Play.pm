package Game::State::Play;
use strict;
use warnings;
use Carp;


sub new
{
	my ($class, @args) = @_;

	my $self = {};

	$self = bless( $self, $class );

	return $self;

}

sub event_handler
{

	warn 'Handling Events in Play Mode';

}

sub move_handler
{

	warn 'Moving stuff in Play Mode';
	#move the ball
	#move the paddle
	#trigger events to send to network

}

sub show_handler
{

	warn 'Showing stuff in Play Mode';
	#draw the planets
	#show the ball
    #draw the paddle
		

}

1;
