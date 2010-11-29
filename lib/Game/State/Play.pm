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

    #Set the score!

    my $app = $game->app();

    $game->{scores} = [ 0, 0 ];
    $app->draw_rect( [ 0, 0, $app->w, $app->h ], [ 0, 0, 0, 255 ] );
    my $event_handler = sub {

        my ( $event, $app ) = @_;

        if ( $event->type == SDL_KEYDOWN ) {
            my $key = SDL::Events::get_key_name( $event->key_sym );
            if ( $key eq 'escap' ) {
                $self->{next} = 'back';
                $app->stop();
            }
        }

    };
    my $show_handler = sub {
        my ( $delta, $app ) = @_;

        $self->_draw_planets( $delta, $app, $game );

        $self->_draw_score( $delta, $app, $game );
    };

    my $clear_screen = sub {

        my ( $delta, $app ) = @_;
        $app->draw_rect( [ 0, 0, $app->w, $app->h ], [ 0, 0, 0, 255 ] );

    };

    $app->add_show_handler($clear_screen);

    $app->add_show_handler($show_handler);

    $game->{paddle} = Game::Object::Paddle->new( app => $app );

    $self->{ball} = Game::Object::Ball->new(
        app  => $app,
        game => $game,
        x    => 350,
        y    => 650,
        v_x  => 10,
        v_y  => 10,
    );

    $app->add_move_handler( sub { $self->_send_recv_score($game) } );

    $app->add_event_handler($event_handler);

    $app->add_show_handler( sub { $_[1]->update() } );
}

sub _draw_planets {
    my ( $self, $delta, $app, $game ) = @_;

    my @planets = @{ $game->level };

    foreach my $planet (@planets) {

        $app->draw_circle_filled( [ $planet->{x}, $planet->{y} ],
            $planet->{size}, [ 255, 0, 0, 255 ] );

    }

}

sub _send_recv_score {
    my ( $self, $game ) = @_;

    if ( $self->{ball}->{updated_score} ) {
        $self->{ball}->{updated_score} = 0;

        $game->{remote}->print( "4|" . $game->{scores}->[0] );

    }

    my $data = $game->{socket_reader}->recv();

    if ( $data && $data =~ /^(4)(\|)(\S+)$/ ) {
        $game->{scores}->[1] = $3;

    }

    if ( $game->{scores}->[0] > 10 ) {
        $game->{lost} = 1;
    }
    elsif ( $game->{scores}->[1] > 10 ) {

        $game->{lost} = 2;

    }

    if ( $game->{lost} ) {
        $self->{next} = 'end';
        $game->{app}->stop();

    }

}

sub _draw_score {
    my ( $self, $delta, $app, $game ) = @_;

    $app->draw_gfx_text(
        [ 10, 10 ],
        [ 255, 0, 0, 255 ],
        "You: " . $game->{scores}->[0] . " Opponent: " . $game->{scores}->[1]
    );

}

1;
