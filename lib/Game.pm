package Game;
use strict;
use warnings;

use Carp;

use SDL;
use SDL::Video;
use SDL::Event;
use SDLx::App;

use Game::State::Play;
use Game::State::Menu;
use Game::State::EndGame;
use Game::State::JoinGame;
use Game::State::CreateGame;
use Game::State::CreateLevel;

my $SINGLETON;

# The transition table between states
my $STATES = {
    'Game::State::Menu' => {
        create_game => 'Game::State::CreateGame',
        join_game   => 'Game::State::JoinGame',
    },
    'Game::State::JoinGame' => {
        back         => 'Game::State::Menu',
        create_level => 'Game::State::CreateLevel',
    },
    'Game::State::CreateGame' => {
        back         => 'Game::State::Menu',
        create_level => 'Game::State::CreateLevel',
    },
    'Game::State::CreateLevel' => {
        back => 'Game::State::Menu',
        play => 'Game::State::Play',
    },
    'Game::State::Play' => {
        back => 'Game::State::Menu',
        end  => 'Game::State::EndGame'
    },
    'Game::State::EndGame' => { back => 'Game::State::Menu', }
};

sub get_singleton {
    return $SINGLETON if ($SINGLETON);

    $SINGLETON = Game->new();

    return $SINGLETON

}

sub start {

    my $game = get_singleton();

    my $current_state = 'Game::State::Menu';

    while ( !$game->{quit} ) {

        my $concrete_state = $current_state->load($game);

        my $global_quit_callback = sub {
            if ( $_[0]->type == SDL_QUIT ) {
                $concrete_state->next = undef;

                # If we are connected tell the others we are done
                if ( $game->{remote} ) {
                    $game->{remote}->print("-1");
                }

                $_[1]->stop();

            }

        };

        $game->app->add_event_handler($global_quit_callback);

        $game->app->run();

        $game->app->remove_all_handlers();

        my $next = $concrete_state->next();

        unless ($next) {
            print 'Finished at state ' . $current_state . "\n";
            $game->{quit} = 1;
        }
        else {
            $current_state = $STATES->{$current_state}->{$next};
        }
    }
}

sub new {
    my ($class) = shift;
    my $self = {};
    $self = bless( $self, $class );

    $self->_initialize();
    return $self;

}

# PUBLIC Attributes

sub app : lvalue {

    #Return the app of the first variable
    # This will be $self if $self->app is called
    $_[0]->{app};
}

# This will store our level that is recieved from
# the network
sub level : lvalue {

    $_[0]->{level};

}

# PRIVATE Methods

sub _initialize {
    my $self = shift;

    #Add an SDLx::App to hold

    $self->{app} = SDLx::App->new(
        width  => 700,
        height => 700,

        #We want double buffering
        flags => SDL_HWSURFACE | SDL_DOUBLEBUF,

        #We only want video initialized for now
        init => SDL_INIT_VIDEO,

        #Title
        title      => "Gravong Client",
        icon       => "data/grav_32.bmp",
        icon_title => "Gravong"
    );

    #Update the screen once

    $self->{app}->update();

    $self->{connected} = 0;

}

1;
