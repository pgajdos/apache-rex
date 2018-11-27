exit_code=0

. ../lib/processman

# http://events.linuxfoundation.org/sites/events/files/slides/AC2014-FastCGI.pdf

# run fcgi application via spawn-fcgi
cp showenv.pl $AREX_RUN_DIR
chmod 755     $AREX_RUN_DIR/showenv.pl
spawn-fcgi -P $AREX_RUN_DIR/spawn-fcgi.pid -a 127.0.0.1 -p $AREX_FCGI_PORT $AREX_RUN_DIR/showenv.pl 
sleep 1

echo
echo "[1] request is proxied to fcgi application"
curl -s http://localhost:$AREX_PORT/app/?a=true | grep 'QUERY_STRING = a=true' || exit_code=1

echo
echo -n 'Stopping spawn-fcgi ... '
kill_pid_port $(cat $AREX_RUN_DIR/spawn-fcgi.pid) $AREX_FCGI_PORT && echo 'done.' || echo 'FAILED.'

exit $exit_code
