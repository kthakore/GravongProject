package Game::State::CreateLevel;
use strict;
use warnings;
use base 'Game::State';
use SDL::Events;

sub load {
	my ( $class, $game ) = @_;

	my $self = bless( {}, $class );
	my $app = $game->app();
	$app->draw_rect( [ 0, 0, $app->w, $app->h ], [ 0, 0, 0, 255 ] );

	$self->_initialize();
	my $event_handler = sub {

		my ( $event, $app ) = @_;

		if ( $event->type == SDL_KEYDOWN ) {

			my $key = SDL::Events::get_key_name( $event->key_sym ) ;

			if( $key eq 'left' )
			{
				$self->{next} = 'back';
				$app->stop();
			}
			if ( $key eq 'right' )
			{
#TODO: GET THIS FROM NETWORK LAND
				$game->level = $self->{planets};
				$self->{next} = 'play';
				$app->stop();
			}
		}

		$self->_drawing_mouse_handler(@_);

	};

	my $move_handler = sub { };

	my $show_handler = sub {
		my ( $delta, $app ) = @_;
		$app->draw_gfx_text( [ 10, 10 ], [ 255, 0, 0, 255 ], "Created Level" );

		$self->_draw_planets(@_);

		$app->update();
	};

	$app->add_event_handler($event_handler);

	$app->add_show_handler($show_handler);

	return $self;

}

# Are we placing, expanding or finishing
sub current_state : lvalue {
	$_[0]->{current_state};
}

sub planets : lvalue {

	$_[0]->{planets};
}

sub _initialize {
	my $self = shift;

	$self->planets       = [];
	$self->current_state = 'nil';

}

sub _drawing_mouse_handler {
	my ( $self, $event, $app ) = @_;

# We clicked. So go make a planet there
	if ( $self->current_state eq 'nil' && $event->type == SDL_MOUSEBUTTONDOWN )
	{
		my ( $mask, $x, $y ) = @{ SDL::Events::get_mouse_state() };
		push( @{ $self->planets }, { x => $x, y => $y, size => 10 } );

		$self->{current_planet} = $#{ $self->planets };

		$self->current_state = 'placing';
	}

	my $c_size = 0;

	if ( $self->current_state eq 'placing' && $event->type == SDL_MOUSEMOTION )
	{
		$c_size = $self->planets->[ $self->{current_planet} ]->{size}++;
	}
	if (   $self->current_state eq 'placing'
			&& ( $event->type == SDL_MOUSEBUTTONUP || $c_size > 80) 
	   )
	{

#We are done placing the planet
		$self->current_state = 'nil';
	}

}

sub _draw_planets {
	my ( $self, $delta, $app ) = @_;

	my @planets = @{ $self->planets };

	foreach my $planet (@planets) {

		$app->draw_circle_filled( [ $planet->{x}, $planet->{y} ],
				$planet->{size}, [ 255, 0, 0, 255 ],1  );

	}

}

1;
