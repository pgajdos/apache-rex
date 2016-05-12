exit_code=0

echo -n 'Starting the scgi server ... '
cp dummy-scgi-server.py $AREX_RUN_DIR
python $AREX_RUN_DIR/dummy-scgi-server.py $AREX_SCGI_PORT&
sleep 1
scgi_server_pid=$(lsof -i | grep ":$AREX_SCGI_PORT (LISTEN)" | sed 's:[^ ]\+[ ]\+\([0-9]\+\).*:\1:')
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
kill -KILL $scgi_server_pid
sleep 1
lsof -i | grep ":$AREX_SCGI_PORT (LISTEN)" && echo 'FAILED.' || echo 'done.'

exit $exit_code
