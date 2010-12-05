package Game::Object::Socket;
use strict;
use warnings;
use IO::Socket;
use Net::Address::IP::Local;

$| = 1;

sub new {
    my ( $class, %args ) = @_;

    my $self = \%args;
    $self = bless $self, $class;

    if ( $self->{remote} ) {
        $self->{game}->{remote_ip}   = $self->{remote_ip};
        $self->{game}->{remote_port} = $self->{remote_port};

        $self->{game}->{remote_sock_inet} = IO::Socket::INET->new(
            PeerAddr => $self->{game}->{remote_ip},
            PeerPort => $self->{game}->{remote_port},
            Proto    => 'udp',
            Blocking => 0
        );

        die " Cannot create socket: $! \n"
          unless $self->{game}->{remote_sock_inet};

    }
    else {

	
      eval(' $self->{game}->{local_ip} = Net::Address::IP::Local->connected_to("173.194.32.104"); ');
		if( $@ ) { 
			printf ( STDERR "Couldn't get public address: $@ \n Trying local lan ");
		
			if( $@) 
			{

				eval(' $self->{game}->{local_ip} = Net::Address::IP::Local->public(); ' );	
				printf ( STDERR "Couldn't get local lan address: $@ \n Using 127.0.0.1 ");

				$self->{game}->{local_ip} = '127.0.0.1'; 
			}
		}
        $self->{game}->{port}     = int( rand( 65535 - 49151 ) + 49151 );
        $self->{game}->{ipp} =
          $self->{game}->{local_ip} . ':' . $self->{game}->{port};

        $self->{game}->{sock_inet} = IO::Socket::INET->new(
            LocalPort => $self->{game}->{port},
            Proto     => 'udp',
            Blocking  => 0
        );
        die " Cannot create socket: $! \n" unless $self->{game}->{sock_inet};

    }

    return $self;
}

sub socket_in : lvalue {

    $_[0]->{game}->{socket_in};
}

sub recv {
    my ($self) = shift;

    my $time = 0;

    my $data = '';

    my $server = $self->{game}->{sock_inet};

    $server->recv( $data, 1024 );
    return $data;

}

sub print {
    my ( $self, $data ) = @_;

    $self->{game}->{remote_sock_inet}->send($data);

}

1;
