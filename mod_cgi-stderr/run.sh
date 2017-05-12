exit_code=0

cgi_dir=$AREX_RUN_DIR/cgi-bin
mkdir -p  $cgi_dir

echo "[1] script output to stderr is seen in error_log"
cat << EOF > $cgi_dir/stderr.cgi
#!/bin/bash
echo 'Content-type: text/html'
echo ''
echo 'Sending a message to stderr'
echo 'I am an ERROR' 1>&2
EOF
chmod 755 $cgi_dir/stderr.cgi
curl -s http://localhost:$AREX_PORT/cgi-bin/stderr.cgi
grep '\[cgi:error\] \[pid.*I am an ERROR' $AREX_RUN_DIR/error_log || exit_code=1

exit $exit_code

