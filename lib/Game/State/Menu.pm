package Game::State::Menu;
use strict;
use warnings;
use base 'Game::State';
use SDLx::Widget::Menu;

sub load {

    my ( $class, $game ) = @_;

    my $self = bless( {}, $class );

    $self->{title_screen} = SDLx::Surface->load('data/images/title.png');

    $self->{menu} = SDLx::Widget::Menu->new(
        font         => 'data/liberationserif-bold.ttf',
        font_color   => [ 200, 200, 200 ],
        select_color => [ 0, 0, 200 ],

        #  change_sound => 'data/menu_select.ogg',
      )->items(
        'Create Game' => sub { $self->{next} = 'create_game'; },
        'Join Game'   => sub { $self->{next} = 'join_game'; },
        'Quit'        => sub { $self->{next} = 'quit' },
      );

    my $app = $game->app();

    $app->draw_rect( [ 0, 0, $app->w, $app->h ], [ 0, 0, 0, 255 ] );

    $app->add_event_handler(
        sub {
            my $status = $self->{menu}->event_hook( $_[0] );
            if ( $status ne 1 || $self->{next} ) { $_[1]->stop(); }
        }
    );
    $app->add_move_handler( sub { } );
    $app->add_show_handler(
        sub {
            $_[1]->blit_by(
                $self->{title_screen},
                [ 0,   0,   480, 480 ],
                [ 100, 100, 480, 480 ]
            );
            $self->{menu}->render( $_[1] );
            $_[1]->update();
        }
    );
    return $self;

}

1;
