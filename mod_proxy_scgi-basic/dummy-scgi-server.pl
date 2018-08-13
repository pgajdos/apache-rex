#!/usr/bin/perl
 
use strict;
use warnings;
 
use SCGI;
use IO::Socket::INET;
use Data::Dumper;

my $port = shift;
 
my $socket = IO::Socket::INET->new(
  Listen => 5,
  ReuseAddr => SO_REUSEADDR,
  LocalPort => $port
) or die "cannot bind to port $port: $!";
 
my $scgi = SCGI->new($socket, blocking => 1);
 
while (my $request = $scgi->accept) {
  $request->read_env;
  $request->connection->print("Content-Type: text/plain\n\n");
  $request->connection->print(Dumper $request->env);
  $request->close;
}
