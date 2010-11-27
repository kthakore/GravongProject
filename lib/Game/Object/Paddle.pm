package Game::Object::Paddle;
use strict;
use warnings;
use Carp;
use SDL::Events;

use Data::Dumper;

sub new {
	my $class = shift;
	my %args  = @_;

	my $self = \%args;

	$self = bless( $self, $class );

	$self->_initialize();

	return $self;

}

sub x : lvalue
{
	return $_[0]->{x}
}

sub y : lvalue
{
	return $_[0]->{y}
}

sub w : lvalue
{
	return $_[0]->{w}
}

sub h : lvalue
{
	return $_[0]->{h}
}

sub _initialize {
	my ($self) = shift;

	my $app = $self->{app};

	$self->{vx} = 0;
	
	$self->{x} = $app->w/2;
	$self->{y} = 600;
	$self->{w} = 100;
	$self->{h} = 10;

#Add the event handler 
	$app->add_event_handler( sub { event_handler($self, @_ ) } );
#Add the move handler
	$app->add_move_handler( sub { move_handler($self, @_ ) } );
#Attach the show handler
	$app->add_show_handler( sub { show_handler($self, @_ ) } );

	}


sub event_handler
{
	my ($self, $event,  $app) = @_;
	if( $event->type == SDL_KEYDOWN )
	{
		my $key = SDL::Events::get_key_name ( $event->key_sym );

		if ( $key eq 'a' )
		{
			$self->{vx} = -10;
		} 

		if ( $key eq 'd' )
		{
			$self->{vx} = 10;	
		}

	}
	elsif ( $event->type == SDL_KEYUP )
	{
		$self->{vx} = 0;
	}

}

sub move_handler
{
	my ($self, $delta, $app, $t) = @_;


	if ( ( $self->{x} < $app->w ) || (  $self->{x} > 0 ) )
	{
		$self->{x} += $self->{vx};
	}

}

sub show_handler
{
	my ($self, $delta, $app) = @_;

	$self->{app}->draw_rect( [$self->{x}, $self->{y}, $self->{w}, $self->{h}], [0,255,0,255]);
}
1;
