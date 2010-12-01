use Config;
system ( split ' ', 'cpan YAML CPAN Alien::SDL pip Mouse Net::Address::IP::Local App::Packer::PAR SDL SDLx-Widget');

system ( split ' ', 'perl SDLpp.pl --output=gravong_'.$Config{archname}. ' --libs=SDL,SDL_main,SDL_gfx --input=gravong.pl --include=lib --more=Game,Clipboard::Xclip' );
