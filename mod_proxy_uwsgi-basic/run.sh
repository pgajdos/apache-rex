exit_code=0

# install an application
cp helloworld.py $AREX_RUN_DIR/
# run uwsgi daemon
echo -n "Starting uWSGI daemon .. "
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
echo

echo "[1] run an uWSGI application"
curl -s http://localhost:$AREX_PORT/ | grep "Hello World!" || exit_code=1

# stop uwsgi daemon
echo
echo -n "Stopping uWSGI daemon .."
kill $(cat $AREX_RUN_DIR/uwsgi.pid) && echo 'done.' || echo 'FAILED.'

exit $exit_code

