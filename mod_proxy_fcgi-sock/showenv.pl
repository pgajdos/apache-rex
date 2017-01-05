#!/usr/bin/perl
use FCGI;
my $request = FCGI::Request();
while ($request->Accept() >= 0) {
  print "Content-Type: text/plain\r\n\r\n";
  foreach my $env (keys %ENV) {
    print "env $env = $ENV{$env}\n";
  }
}
