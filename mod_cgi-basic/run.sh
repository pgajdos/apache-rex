exit_code=0

cgi_dir=$AREX_RUN_DIR/cgi-bin
mkdir -p  $cgi_dir

echo "[1] correct cgi script"
cat << EOF > $cgi_dir/correct.cgi
#!/bin/bash
echo 'Content-type: text/html'
echo ''
echo 'CGI Bash Example'
EOF
chmod 755 $cgi_dir/correct.cgi
curl -s http://localhost:$AREX_PORT/cgi-bin/correct.cgi | grep 'CGI Bash Example' || exit_code=1

echo "[2] incorrect cgi script"
cat << EOF > $cgi_dir/wrong.cgi
#!/bin/bash
echo 'CGI Bash Example'
EOF
chmod 755 $cgi_dir/wrong.cgi
curl -s http://localhost:$AREX_PORT/cgi-bin/wrong.cgi | grep '500 Internal Server Error' || exit_code=2

echo "[3] correct cgi script without executable bits"
chmod 644 $cgi_dir/correct.cgi
curl -s http://localhost:$AREX_PORT/cgi-bin/correct.cgi | grep '500 Internal Server Error' || exit_code=3

echo "[4] perl cgi script"
cat << EOF > $cgi_dir/script.pl
#!/usr/bin/perl
use strict;
use warnings;

print "Content-type: text/html\r\n";
print "\r\n";
print "perl cgi example\r\n";
1;
EOF
chmod 755 $cgi_dir/script.pl
curl -s http://localhost:$AREX_PORT/cgi-bin/script.pl | grep 'perl cgi example' || exit_code=4

exit $exit_code

