exit_code=0

cgi_dir=$AREX_RUN_DIR/cgi-bin
mkdir -p  $cgi_dir

echo "[1] curl does not get PROTOCOL_ERROR"
cat << EOF > $cgi_dir/test.pl
#!/usr/bin/perl
print "Content-Type: text/html\n\n";
EOF
chmod 755 $cgi_dir/test.pl
curl -k --http2 --head https://localhost:$AREX_PORT/cgi-bin/test.pl 2>&1 | grep PROTOCOL_ERROR && exit_code=1

exit $exit_code
