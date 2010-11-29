package Game::State::EndGame;
use strict;
use warnings;
use base 'Game::State';

use SDL::Events;

sub load {

    my ( $class, $game ) = @_;

    my $app = $game->{app};

    my $who_won = "whut";

    $who_won = "You lost" if $game->{lost} == 1;
    $who_won = "You won"  if $game->{lost} == 2;

    $app->draw_gfx_text( [ $app->w / 2, $app->h / 2 ],
        $who_won, [ 255, 0, 0, 255 ] );

    sleep(1);

    $app->stop();
}

1;
