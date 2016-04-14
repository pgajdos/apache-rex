exit_code=0

echo "[1] Test 404 from localhost"
echo '1234' > $AREX_DOCUMENT_ROOT/index.html
curl -s http://localhost:$AREX_RUN_PORT/ > /dev/null
echo '12345' > $AREX_DOCUMENT_ROOT/index.html
curl -s http://localhost:$AREX_RUN_PORT/ > /dev/null
rx_microseconds=""
if [ $AREX_APACHE_VERSION -ge 20413 ]; then
  rx_microseconds="[0-9]\+ "
fi
head -n 1 $AREX_RUN_DIR/my_log | grep "\(127.0.0.1\|::1\) 200 ${rx_microseconds}[0-9]\+ [0-9]\+" || exit_code=1
tail -n 1 $AREX_RUN_DIR/my_log | grep "\(127.0.0.1\|::1\) 200 ${rx_microseconds}[0-9]\+ [0-9]\+" || exit_code=1
exit $exit_code
