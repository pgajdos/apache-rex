exit_code=0

cp timeout-test.py $AREX_RUN_DIR

echo 'main index' > $AREX_DOCUMENT_ROOT/index.html

if [ $AREX_APACHE_VERSION -ge 20400 ]; then
  HEADER_TIMEOUT_ERROR='408 Request Timeout'
elif [ $AREX_APACHE_VERSION -ge 20232 ]; then
  HEADER_TIMEOUT_ERROR='408 Request Time-out'
else
  HEADER_TIMEOUT_ERROR='400 Bad Request'
fi

if [ $AREX_APACHE_VERSION -ge 20425 ]; then
  BODY_TIMEOUT_ERROR='408 Request Timeout'
else
  BODY_TIMEOUT_ERROR='400 Bad Request'
fi

echo "[1] header read timeout"
python $AREX_RUN_DIR/timeout-test.py localhost $AREX_PORT / 2 header | grep "$HEADER_TIMEOUT_ERROR" || exit_code=1
cat $AREX_RUN_DIR/error_log | grep 'Request header read timeout' || exit_code=1

echo "[2] body read timeout"
python $AREX_RUN_DIR/timeout-test.py localhost $AREX_PORT / 2 body   | grep "$BODY_TIMEOUT_ERROR"   || exit_code=2
cat $AREX_RUN_DIR/error_log | grep 'Request body read timeout'   || exit_code=2

echo "[3] no timeout"
python $AREX_RUN_DIR/timeout-test.py localhost $AREX_PORT /          | grep 'main index'            || exit_code=3

exit $exit_code
