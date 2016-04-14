#!/usr/bin/perl
# using one script for authentication and authorization (it is actually
# called only once, during authentication, see the doc)
# http://httpd.apache.org/docs/2.4/mod/mod_authnz_fcgi.html#invocations
use FCGI;
my $request = FCGI::Request();
while ($request->Accept() >= 0) {
    die if $ENV{'FCGI_APACHE_ROLE'};
    die if $ENV{'FCGI_ROLE'} ne "AUTHORIZER";
    die if !$ENV{'REMOTE_PASSWD'};
    die if !$ENV{'REMOTE_USER'};

    print STDERR "authenticating $ENV{'REMOTE_USER'}\n";

    if (($ENV{'REMOTE_USER'} eq "puskvorec"  && $ENV{'REMOTE_PASSWD'} eq "PuskvorecsPassword") || 
        ($ENV{'REMOTE_USER'} eq "brcalnik"   && $ENV{'REMOTE_PASSWD'} eq "BrcalniksPassword")) {
        print "Status: 200\n\n";
        print "You are not allowed to see the content.\n"
    }
    else {
        print "Status: 401\n\n";
    }
}
