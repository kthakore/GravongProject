package Game::State::EndGame;
use strict;
use warnings;
use base 'Game::State';

use SDL::Events;

sub load {

    my ( $class, $game ) = @_;

	my $self = {};

	$self = bless $self, $class;
    my $app = $game->{app};

    my $who_won = "whut";

    $who_won = "You lost" if $game->{lost} == 1;
    $who_won = "You won"  if $game->{lost} == 2;

	$app->draw_rect( [0,0,$app->w, $app->h], 0 );
    $app->draw_gfx_text( [ $app->w / 2, $app->h / 2 ],
       [ 200, 150, 24, 255 ], $who_won );

	$app->update();

    sleep(1);

	$self->{next} = 'back';
    $app->stop();

	return $self;
}

1;
