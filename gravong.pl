use strict;
use warnings;
use lib 'lib';
use Game; 

#starts ze game
my $game = Game->new();

$game->play_mode();
$game->app->run(); 

