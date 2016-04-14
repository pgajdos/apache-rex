exit_code=0

echo 'main index' > $AREX_DOCUMENT_ROOT/index.html

if [ $AREX_APACHE_BRANCH -ge 204 ]; then
  HEADER_TIMEOUT_ERROR='408 Request Timeout'
else
  HEADER_TIMEOUT_ERROR='400 Bad Request'
fi

echo "[1] header read timeout"
python timeout-test.py localhost $AREX_RUN_PORT / 2 header | grep "$HEADER_TIMEOUT_ERROR" || exit_code=1
cat $AREX_RUN_DIR/error_log | grep 'Request header read timeout' || exit_code=1

echo "[2] body read timeout"
python timeout-test.py localhost $AREX_RUN_PORT / 2 body   | grep '400 Bad Request'     || exit_code=2
cat $AREX_RUN_DIR/error_log | grep 'Request body read timeout'   || exit_code=2

echo "[3] no timeout"
python timeout-test.py localhost $AREX_RUN_PORT /          | grep 'main index'          || exit_code=3

exit $exit_code
