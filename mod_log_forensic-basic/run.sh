exit_code=0

echo index >  $AREX_DOCUMENT_ROOT/index.html

echo "[1] forensic log contains begin and end of processing request"
curl -s http://localhost:$AREX_RUN_PORT/ 
head -n 1 $AREX_RUN_DIR/forensic_log | grep '+.*|GET.*|User-Agent:curl' || exit_code=1
request_id=$(head -n 1 $AREX_RUN_DIR/forensic_log | sed 's:+\(.*\)|GET.*:\1:')
grep "\-$request_id" $AREX_RUN_DIR/forensic_log || exit_code=1

echo "[2] forensic log contains also specified header"
curl -s -X POST -H 'my-header: hello_world' http://localhost:$AREX_RUN_PORT/
grep '+.*|POST.*|my-header:hello_world' $AREX_RUN_DIR/forensic_log || exit_code=2

exit $exit_code
