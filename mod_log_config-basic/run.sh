exit_code=0

echo "[1] Test 404 from localhost"
curl -s http://localhost:$AREX_PORT/ > /dev/null
cat $AREX_RUN_DIR/my_log | grep '\(127.0.0.1\|::1\) \(127.0.0.1\|::1\) 404' || exit_code=1

echo "[2] Test 200 from localhost"
touch $AREX_DOCUMENT_ROOT/index.html
curl -s http://localhost:$AREX_PORT/ > /dev/null
cat $AREX_RUN_DIR/my_log | grep '\(127.0.0.1\|::1\) \(127.0.0.1\|::1\) 200' || exit_code=1

exit $exit_code
