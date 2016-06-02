exit_code=0

echo 'site index' > $AREX_DOCUMENT_ROOT/index.html
echo 'document' > $AREX_DOCUMENT_ROOT/document.html

curl http://localhost:$AREX_PORT/
curl http://localhost:$AREX_PORT/document.html

# just informative output
echo '.................................................'
echo 'requests.firehose'
echo 'length : timestamp : req(<)/res(>) : uuid : count'
echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
cat $AREX_RUN_DIR/requests.firehose
echo '.................................................'
echo '.................................................'
echo 'responses.firehose'
echo 'length : timestamp : req(<)/res(>) : uuid : count'
echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
cat $AREX_RUN_DIR/responses.firehose
echo '.................................................'

# test itself
echo
echo "[1] input log contains dump of requests"
grep 'GET /document.html HTTP/1.1' $AREX_RUN_DIR/requests.firehose  || exit_code=1
grep 'User-Agent: curl'            $AREX_RUN_DIR/requests.firehose  || exit_code=1

echo "[2] output log contains dump of responses"
grep 'site index'                  $AREX_RUN_DIR/responses.firehose || exit_code=2
grep 'Content-Length: 9'           $AREX_RUN_DIR/responses.firehose || exit_code=2

echo "[3] check request start fragment headers"
cat $AREX_RUN_DIR/requests.firehose | tr -d '\r' | grep '^[0-9a-f]\+ [0-9a-f]\+ < [A-Za-z0-9@-]\+ 0$' | tee $AREX_RUN_DIR/request_fragment_start_headers
cat $AREX_RUN_DIR/request_fragment_start_headers | wc -l | grep 2 || exit_code=3

echo "[4] check request end fragment headers"
cat $AREX_RUN_DIR/requests.firehose | tr -d '\r' | grep '^0 [0-9a-f]\+ < [A-Za-z0-9@-]\+ [0-9a-f]\+$' | tee $AREX_RUN_DIR/request_fragment_end_headers
cat $AREX_RUN_DIR/request_fragment_end_headers | wc -l | grep 2 || exit_code=4

echo "[5] check response start fragment headers"
cat $AREX_RUN_DIR/responses.firehose | tr -d '\r' | grep '^[0-9a-f]\+ [0-9a-f]\+ > [A-Za-z0-9@-]\+ 0$' | tee $AREX_RUN_DIR/response_fragment_start_headers
cat $AREX_RUN_DIR/response_fragment_start_headers | wc -l | grep 2 || exit_code=5

echo "[6] check request end fragment headers"
cat $AREX_RUN_DIR/responses.firehose | tr -d '\r' | grep '^0 [0-9a-f]\+ > [A-Za-z0-9@-]\+ [0-9a-f]\+$' | tee $AREX_RUN_DIR/response_fragment_end_headers
cat $AREX_RUN_DIR/response_fragment_end_headers | wc -l | grep 2 || exit_code=6

exit $exit_code
