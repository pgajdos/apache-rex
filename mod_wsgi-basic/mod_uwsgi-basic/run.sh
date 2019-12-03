exit_code=0

# install an application
cp helloworld.py $AREX_RUN_DIR/
# start uwsgi daemons
echo -n "Starting first uWSGI daemon (speaks uwsgi) .. "
uwsgi --plugin $AREX_UWSGI_PLUGIN_PYTHON \
      --socket localhost:$AREX_UWSGI_PORT \
      --wsgi-file $AREX_RUN_DIR/helloworld.py \
      --pidfile $AREX_RUN_DIR/uwsgi.pid \
      --logto $AREX_RUN_DIR/uwsgi.log &
sleep 1
if [ -e "$AREX_RUN_DIR/uwsgi.pid" ]; then
  echo "$(cat $AREX_RUN_DIR/uwsgi.pid)."
else
  echo "FAILED, see $AREX_RUN_DIR/uwsgi.log."
  exit 1
fi

echo "[1] run an uWSGI application, uwsgi protocol"
curl -s http://localhost:$AREX_PORT/ #| grep "Hello World!" || exit_code=1

# stop uwsgi daemon
echo
echo -n "Stopping uWSGI daemons .. "
kill $(cat $AREX_RUN_DIR/uwsgi.pid) \
  && echo -n 'done.' || echo 'FAILED.'

exit $exit_code

