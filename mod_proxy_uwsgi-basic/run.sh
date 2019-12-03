exit_code=0

# install an application
cp helloworld.py $AREX_RUN_DIR/
# start uwsgi daemons
echo -n "Starting first uWSGI daemon (speaks uwsgi) .. "
uwsgi --plugin $AREX_UWSGI_PLUGIN_PYTHON \
      --socket localhost:$AREX_UWSGI_PORT \
      --wsgi-file $AREX_RUN_DIR/helloworld.py \
      --pidfile $AREX_RUN_DIR/uwsgi-1.pid \
      --logto $AREX_RUN_DIR/uwsgi-1.log &
sleep 1
if [ -e "$AREX_RUN_DIR/uwsgi-1.pid" ]; then
  echo "$(cat $AREX_RUN_DIR/uwsgi-1.pid)."
else
  echo "FAILED, see $AREX_RUN_DIR/uwsgi-1.log."
  exit 1
fi
echo -n "Starting second uWSGI daemon (speaks http) .. "
uwsgi --plugin $AREX_UWSGI_PLUGIN_PYTHON,$AREX_UWSGI_PLUGIN_HTTP \
      --http localhost:$AREX_UWSGI_PORT2 \
      --wsgi-file $AREX_RUN_DIR/helloworld.py \
      --pidfile $AREX_RUN_DIR/uwsgi-2.pid \
      --logto $AREX_RUN_DIR/uwsgi-2.log &
sleep 1
if [ -e "$AREX_RUN_DIR/uwsgi-2.pid" ]; then
  echo "$(cat $AREX_RUN_DIR/uwsgi-2.pid)."
else
  echo "FAILED, see $AREX_RUN_DIR/uwsgi-2.log."
  exit 1
fi
echo

echo "[1] run an uWSGI application, uwsgi protocol"
curl -s http://localhost:$AREX_PORT/uwsgi/ | grep "Hello World!" || exit_code=1

echo "[2] run an uWSGI application, http protocol"
curl -s http://localhost:$AREX_PORT/http/ | grep "Hello World!" || exit_code=2

# stop uwsgi daemon
echo
echo -n "Stopping uWSGI daemons .. "
kill $(cat $AREX_RUN_DIR/uwsgi-1.pid) $(cat $AREX_RUN_DIR/uwsgi-2.pid) \
  && echo -n 'done.' || echo 'FAILED.'

exit $exit_code

