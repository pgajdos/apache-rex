exit_code=0

. ../lib/processman

echo -n 'Starting the scgi server ... '
cp dummy-scgi-server.pl $AREX_RUN_DIR
perl $AREX_RUN_DIR/dummy-scgi-server.pl $AREX_SCGI_PORT&
sleep 1
scgi_server_pid=$(get_pid $AREX_SCGI_PORT)
if [ -z "$scgi_server_pid" ]; then
  echo "FAILED."
  exit 1
fi
echo $scgi_server_pid
echo

echo "[1] run proxy on scgi server which returns its environment"

curl -s http://localhost:$AREX_PORT/app/ > $AREX_RUN_DIR/env-scgi-server.out
grep 'REQUEST_METHOD.*GET' $AREX_RUN_DIR/env-scgi-server.out || exit_code=1
grep 'SCGI.*1'             $AREX_RUN_DIR/env-scgi-server.out || exit_code=1

echo
echo -n 'Stopping the scgi server ... '
kill_pid $scgi_server_pid $AREX_SCGI_PORT && echo 'done.' || echo 'FAILED.'

exit $exit_code
