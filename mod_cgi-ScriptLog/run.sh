exit_code=0

cgi_dir=$AREX_RUN_DIR/cgi-bin
mkdir -p  $cgi_dir

cat << EOF > $cgi_dir/script.cgi
#!/bin/bash
echo 'Content-type: text/html'
echo ''
echo 'Hello from CGI'
EOF
cat << EOF > $cgi_dir/stderr.cgi
#!/bin/bash
echo 'Content-type: text/html'
echo ''
echo 'Sending a message to stderr'
echo 'I am an ERROR' 1>&2
EOF
chmod 755 $cgi_dir/script.cgi
chmod 755 $cgi_dir/stderr.cgi
curl -s http://localhost:$AREX_PORT/cgi-bin/script.cgi
curl -s http://localhost:$AREX_PORT/cgi-bin/stderr.cgi > /dev/null
curl -s http://localhost:$AREX_PORT/cgi-bin/notexisting.cgi > /dev/null

echo "[1] a correct hit has not a record in script_log"
grep '200.*script.cgi' $AREX_RUN_DIR/script_log && exit_code=1

echo "[2] an error from CGI script has a record in script_log"
grep '200.*stderr.cgi' $AREX_RUN_DIR/script_log || exit_code=2
grep 'I am an ERROR' $AREX_RUN_DIR/script_log || exit_code=2

echo "[3] the error is still logged in error_log (see mod_cgi-stderr example)"
grep '\[cgi:error\] \[pid.*I am an ERROR' $AREX_RUN_DIR/error_log || exit_code=1
 
echo "[4] 404 has a record in script_log"
grep '404.*notexisting.cgi' $AREX_RUN_DIR/script_log || exit_code=4

exit $exit_code

