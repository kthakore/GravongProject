package Game::State::Play;
use strict;
use warnings;
use base 'Game::State';
use SDL::Events;
use Game::Object::Ball;
use Game::Object::Paddle;

sub load {
    my ( $class, $game ) = @_;

    my $self = bless( {}, $class );

    $self->_initialize($game);
    return $self;

}

sub _initialize {
    my ( $self, $game ) = @_;

    my $app = $game->app();
    $app->draw_rect( [ 0, 0, $app->w, $app->h ], [ 0, 0, 0, 255 ] );
    my $event_handler = sub {

        my ( $event, $app ) = @_;

        if ( $event->type == SDL_KEYDOWN ) {
            my $key = SDL::Events::get_key_name( $event->key_sym );
            if ( $key eq 'left' ) {
                $self->{next} = 'back';
                $app->stop();
            }
            elsif ( $key eq 'right' ) {
                $self->{next} = 'end';
                $app->stop();
            }
        }

    };

    my $move_handler = sub { };

    my $show_handler = sub {
        my ( $delta, $app ) = @_;
        $app->draw_gfx_text( [ 10, 10 ], [ 255, 0, 0, 255 ], "Playing Game" );

        $self->_draw_planets( $delta, $app, $game );

        $app->update();
    };

    my $clear_screen = sub {

        my ( $delta, $app ) = @_;
        $app->draw_rect( [ 0, 0, $app->w, $app->h ], [ 0, 0, 0, 255 ] );

    };

    $app->add_show_handler($clear_screen);

    #TODO: Check $game->player and make $ball from new $x, $y only if we are
    #player 1
    $self->{ball} = Game::Object::Ball->new(
        app   => $app,
        level => $game->level,
        x     => 350,
        y     => 650
    );

	$self->{paddle} = Game::Object::Paddle->new(
		app   => $app 
	);

    $app->add_event_handler($event_handler);

    $app->add_show_handler($show_handler);

}

sub _draw_planets {
    my ( $self, $delta, $app, $game ) = @_;

    my @planets = @{ $game->level };

    foreach my $planet (@planets) {

        $app->draw_circle_filled( [ $planet->{x}, $planet->{y} ],
            $planet->{size}, [ 255, 0, 0, 255 ] );

    }

}

1;
