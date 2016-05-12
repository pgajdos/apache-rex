exit_code=0

# start a websocket application example
cp ws-test-{client,server}.py $AREX_RUN_DIR/
# use $AREX_PORT1 port for this server
python $AREX_RUN_DIR/ws-test-server.py \
   --ip=127.0.0.1 \
   --port=$AREX_PORT1 \
   --uri="/reverse-echo/" \
   --pid-file=$AREX_RUN_DIR/ws-server-pid &
sleep 1

echo "[1] get the same response via ws server and http proxy"
python $AREX_RUN_DIR/ws-test-client.py --url="ws://127.0.0.1:$AREX_PORT/" > result-with-proxy
python $AREX_RUN_DIR/ws-test-client.py --url="ws://127.0.0.1:$AREX_PORT1/reverse-echo/" > result-without-proxy
grep 'dlrow olleh' result-with-proxy || exit_code=1
diff result-with-proxy result-without-proxy || exit_code=1

# stop the websocket server
kill -TERM $(cat $AREX_RUN_DIR/ws-server-pid)
rm $AREX_RUN_DIR/ws-server-pid

exit $exit_code
