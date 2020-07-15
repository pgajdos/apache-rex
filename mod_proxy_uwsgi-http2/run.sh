exit_code=0

. ../lib/uwsgi

# install an application
cp helloworld.py $AREX_RUN_DIR/
# start uwsgi daemons
uwsgi_daemon_start '1-uwsgi' $AREX_UWSGI_PLUGIN_PYTHON \
                   $AREX_RUN_DIR/helloworld.py $AREX_UWSGI_PORT
uwsgi_daemon_start '2-http'  $AREX_UWSGI_PLUGIN_PYTHON,$AREX_UWSGI_PLUGIN_HTTP \
                   $AREX_RUN_DIR/helloworld.py $AREX_UWSGI_PORT2
echo

echo "[1] run an uWSGI application, uwsgi protocol"
curl -s -k https://localhost:$AREX_PORT1/uwsgi/ | grep "Hello World!" || exit_code=1

echo "[2] run an uWSGI application, http protocol"
curl -s -k https://localhost:$AREX_PORT1/http/ | grep "Hello World!" || exit_code=2

# stop uwsgi daemons
echo
uwsgi_daemon_stop '1-uwsgi' $AREX_UWSGI_PORT
uwsgi_daemon_stop '2-http'  $AREX_UWSGI_PORT2

exit $exit_code

