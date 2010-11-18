package Game;
use strict;
use warnings;

use Carp;

use SDL;
use SDL::Video;
use SDLx::App;
use Game::State::Play;

sub new 
{
	my ($class) = shift;
	my $self = {};
	$self = bless($self, $class);


	$self->_initialize();
	return $self;

}

# PUBLIC Attributes

sub app :lvalue
{
	#Return the app of the first variable
	# This will be $self if $self->app is called
	$_[0]->{app};
}

# PUBLIC Methods

# Go to play_mode
sub play_mode
{
	my $self = shift;

	my $app = $self->{app};

	my $e_handle = $app->add_event_handler( \&Game::State::Play::event_handler );
	my $m_handle = $app->add_move_handler( \&Game::State::Play::move_handler );
	my $s_handle = $app->add_show_handler( \&Game::State::Play::show_handler );

	 $self->{handlers}->[0] = $m_handle;
	 $self->{handlers}->[1] = $s_handle;
	 $self->{handlers}->[2] = $e_handle;

}

# PRIVATE Methods

sub _empty_handlers
{
	 my $self = shift;
	 	
	 $self->{app}->remove_move_handlers( $self->{handlers}->[0] ) if( $self->{handlers}->[0] );
	 $self->{app}->remove_show_handlers( $self->{handlers}->[1] ) if( $self->{handlers}->[1] );
	 $self->{app}->remove_event_handlers( $self->{handlers}->[2] ) if ( $self->{handlers}->[2] );

}

sub _initialize
{
	my $self = shift;

	#Add an SDLx::App to hold

	$self->{app} = SDLx::App->new( 
		width => 700,
		height => 700,
		eoq => 1,
		#We want double buffering
		flags => SDL_HWSURFACE | SDL_DOUBLEBUF,
		#We only want video initialized for now
		init  => SDL_INIT_VIDEO,
		#Title
		title =>"Gravong Client",
		icon => "data/grav_32.bmp",
		icon_title => "Gravong"
	);

	#Update the screen once

	$self->{app}->update();

	#Keep an array of current handlers
	
	$self->{handlers} = [];

}

1;
