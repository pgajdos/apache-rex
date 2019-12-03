exit_code=0

# install an application
cp helloworld.py $AREX_RUN_DIR/

echo "[1] run an uWSGI application"
curl -s http://localhost:$AREX_PORT/helloapp | grep "Hello World!" || exit_code=1

exit $exit_code


