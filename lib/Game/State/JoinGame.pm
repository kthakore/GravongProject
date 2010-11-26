package Game::State::JoinGame;
use strict;
use warnings;
use base 'Game::State';
use SDL::Events;
use SDLx::Widget::Textbox;

sub load{
	my ( $class, $game ) = @_;

	my $self = bless( {}, $class );
	my $app = $game->app();
	$app->draw_rect( [0,0,$app->w, $app->h], [0,0,0,255]);

	my $ipaddress =	SDLx::Widget::Textbox->new(app => $app, x => 200, y => 230, w => 200, h => 20, name => 'ipaddress', focus => 1 );

	my $event_handler = sub {

		my ($event, $app) = @_;

		if( $event->type == SDL_KEYDOWN )
	{
		my $key =  SDL::Events::get_key_name($event->key_sym);
		if( $key eq 'left' )
		{
			$self->{next} = 'back';
			$app->stop();	
		}

		if( $key eq 'return' || $key eq 'enter' )
		{
			$self->{connecting} = 1;
		}
	}

	};


	my $move_handler = sub {

		 $self->{status} = "Type in the ipaddress of the server";

		#Check for connection and go to next stage
		if($game->{connected} && $game->{connected} != -1)
		{	
			$self->{status} = "Connected to: ". $ipaddress->{value};
			$self->{next} = 'create_level';	

			$app->stop();
		}
		elsif( $game->{connected} == -1 )
		{
			$self->{status} = "Cannot connect to ". $ipaddress->{value} ;
			$self->{next} = 'back';
			$app->stop();

		}

		if( $self->{connecting} )
		{
			$self->{status} = "Trying to connect to: ". $ipaddress->{value};

		}


	};

	my $show_handler = sub { 
		my ($delta, $app) = @_;

		$app->draw_rect( [10,10,$app->w,50], [0,0,0,255] );

		$app->draw_gfx_text( [10,10], [255,0,0,255], $self->{status} );

		$ipaddress->show;

		$app->update(); 
	};

	$app->add_event_handler( $event_handler );

	$app->add_show_handler( $show_handler);

	$app->add_move_handler( $move_handler );

	return $self;

}


1;
