#!/usr/bin/perl
print "Content-type: text/plain\n\n";
if ($ENV{'MOD_PERL'}) {
  print "mod_perl$ENV{'MOD_PERL_API_VERSION'} rules!\n";
} else {
  print "perl rules!\n";
}
