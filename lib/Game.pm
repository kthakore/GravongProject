package Game;
use strict;
use warnings;
use SDL;
use SDL::Video;
use SDLx::App;


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

# PRIVATE Methods

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
		title =>"Gravong Client"
	);




}
1;
