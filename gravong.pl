use strict;
use warnings;
use lib 'lib';
use Game; 
use Game::Menu;

#starts ze game
my $game = Game::get_singleton;

Game::Menu->load($game);

$game->app->run(); 

