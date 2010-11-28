package Game::State::CreateGame;
use strict;
use warnings;
use parent 'Game::State';
use SDL::Events;
use Game::Object::Socket;

sub load {
    my ( $class, $game ) = @_;
    my $self = bless( {}, $class );
    my $app = $game->app();
    $app->draw_rect( [ 0, 0, $app->w, $app->h ], [ 0, 0, 0, 255 ] );

    $game->{socket_reader} = Game::Object::Socket->new( game => $game );

    $self->{status} = "Created Game Waiting for Connection on " . $game->{ipp};

    my $event_handler = sub {

        my ( $event, $app ) = @_;

        if ( $event->type == SDL_KEYDOWN ) {
            my $key = SDL::Events::get_key_name( $event->key_sym );
            if ( $key eq 'left' ) {
                $self->{next} = 'back';
                $app->stop();
            }
            elsif ( $key eq 'right' ) {
                $self->{next} = 'create_level';
                $app->stop();
            }
        }

    };

    my $move_handler = sub {

        my $data = $game->{socket_reader}->recv();

        if ( $data && $data =~ /^(1)(\|)(\S+)$/ ) {

            $self->{status} = 'Connected to :' . $3;

            $3 =~ /(\S+)(\:)(\S+)/;

            my $ip   = $1;
            my $port = $3;

            $game->{remote} = Game::Object::Socket->new(
                game        => $game,
                remote      => 1,
                remote_ip   => $ip,
                remote_port => $port
            );

            #Complete hand shake
            $game->{remote}->print("(1)");

            $self->{next} = 'create_level';
            $app->stop();

        }

    };

    my $show_handler = sub {
        my ( $delta, $app ) = @_;

        $app->draw_rect( [ 0, 0, $app->w, $app->h ], [ 0, 0, 0, 255 ] );

        $app->draw_gfx_text( [ 10, 10 ], [ 255, 0, 0, 255 ], $self->{status} );

        $app->update();
    };

    $app->add_event_handler($event_handler);

    $app->add_show_handler($show_handler);

    $app->add_move_handler($move_handler);

    return $self;

}

1;
