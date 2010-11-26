package Game::State;
use strict;
use warnings;

sub next : lvalue {
    return $_[0]->{next};
}

sub load {

}

1;
