exit_code=0

echo 'site index' > $AREX_DOCUMENT_ROOT/index.html
echo 'document' > $AREX_DOCUMENT_ROOT/document.html

curl http://localhost:$AREX_PORT/
curl http://localhost:$AREX_PORT/document.html

# just informative output
echo '.................................................'
echo 'request-input.firehose'
echo 'length : timestamp : req(<)/res(>) : uuid : count'
echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
cat $AREX_RUN_DIR/request-input.firehose
echo '.................................................'
echo '.................................................'
echo 'request-output.firehose'
echo 'length : timestamp : req(<)/res(>) : uuid : count'
echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
cat $AREX_RUN_DIR/request-output.firehose
echo '.................................................'

# test itself
echo
echo "[1] input log contains dump of requests"
grep 'GET /document.html HTTP/1.1' $AREX_RUN_DIR/request-input.firehose  || exit_code=1
grep 'User-Agent: curl'            $AREX_RUN_DIR/request-input.firehose  || exit_code=1
echo "[2] output log contains dump of responses"
grep 'site index'                  $AREX_RUN_DIR/request-output.firehose || exit_code=2
grep 'Content-Length: 9'           $AREX_RUN_DIR/request-output.firehose || exit_code=2

exit $exit_code
