package Game::Menu;
use strict;
use warnings;
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
        'Create Game' => sub { $self->{next} = 'new_game';  0 },
        'Join Game'   => sub { $self->{next} = 'load_game'; 0 },
        'Quit'        => sub { return },
      );

    my $app = $game->app();

    my $e_handle =
      $app->add_event_handler( sub { $self->{menu}->event_hook( $_[0] ) } );
    my $m_handle = $app->add_move_handler( sub { } );
    my $s_handle = $app->add_show_handler(
        sub {
            $_[1]->blit_by(
                $self->{title_screen},
                [ 0, 0, 480, 480 ],
                [ 100, 100, 480, 480 ]
            );
            $self->{menu}->render( $_[1] );
            $_[1]->update();
        }
    );

    $self->{handlers}->[0] = $m_handle;
    $self->{handlers}->[1] = $s_handle;
    $self->{handlers}->[2] = $e_handle;

    return $self;

}

1;
