exit_code=0

echo 'site index' > $AREX_DOCUMENT_ROOT/index.html
echo 'document' > $AREX_DOCUMENT_ROOT/document.html

curl http://localhost:$AREX_PORT/
curl http://localhost:$AREX_PORT/document.html

mkdir -p $AREX_RUN_DIR/demultiplex
firehose -f $AREX_RUN_DIR/requests.firehose --output-directory $AREX_RUN_DIR/demultiplex
firehose -f $AREX_RUN_DIR/responses.firehose --output-directory $AREX_RUN_DIR/demultiplex

echo "[1] \$uuid.request contains dump of the request and \$uuid.response contains response to that request"
for req_dump_filename in $AREX_RUN_DIR/demultiplex/*.request; do
  grep '^GET /' $req_dump_filename || exit_code=1
  # $uuid.request ~ $uuid.response
  res_dump_filename=$(echo $req_dump_filename | sed s:request$:response:)
  grep 'HTTP/1.1 200 OK' $res_dump_filename || exit_code=1
  tail -n 1 $res_dump_filename
done

exit $exit_code
