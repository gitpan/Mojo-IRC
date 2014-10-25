use warnings;
use strict;
use Test::More;
use Mojo::IRC;

plan skip_all => 'MSWin32' if $^O eq 'MSWin32';

{
  my $irc = Mojo::IRC->new(nick => 'test123', stream => dummy_stream());
  my @args;

  $irc->disconnect(sub { @args = @_ });
  is_deeply \@main::buf, ["QUIT\r\n"], 'QUIT is sent';
  is $main::close, 1, 'stream was closed';
  is $args[0], $irc, 'callback was called';
}

done_testing;

sub dummy_stream {
  eval "package Dummy::Stream; sub close { \$main::close++; } sub write { shift; push \@main::buf, shift; shift->() } 1";
  bless {}, "Dummy::Stream";
}
