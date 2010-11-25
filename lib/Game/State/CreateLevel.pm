package Game::State::CreateLevel;
use strict;
use warnings;
use base 'Game::State';
use SDL::Events;

my $DRAW_STATE;


sub load{
	my ( $class, $game ) = @_;

	my $self = bless( {}, $class );
	my $app = $game->app();
	$app->draw_rect( [0,0,$app->w, $app->h], [0,0,0,255]);

	my $event_handler = sub {

		my ($event, $app) = @_;

		if( $event->type == SDL_KEYDOWN )
		{
			$self->{next} = 'back';
			$app->stop();	
		}


	};

	my $move_handler = sub {};

	my $show_handler = sub { 
		my ($delta, $app) = @_;
		$app->draw_gfx_text( [10,10], [255,0,0,255], "Created Level" );

		$app->update(); 
	};


	$app->add_event_handler( $event_handler );

	$app->add_show_handler( $show_handler);



	return $self;


}

1;
