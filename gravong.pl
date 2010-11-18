use strict;
use warnings;
use lib 'lib';
use Game; 

#starts ze game
my $game = Game::get_singleton;

$game->play_mode();
$game->app->run(); 

