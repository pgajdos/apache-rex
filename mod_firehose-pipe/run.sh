exit_code=0

echo 'site index' > $AREX_DOCUMENT_ROOT/index.html
echo 'document'   > $AREX_DOCUMENT_ROOT/document.html
cp apache_pb.png    $AREX_DOCUMENT_ROOT/

curl -s http://localhost:$AREX_PORT/              > /dev/null
curl -s http://localhost:$AREX_PORT/document.html > /dev/null
curl -s http://localhost:$AREX_PORT/apache_pb.png > /dev/null

echo "[1] \$uuid.request contains dump of the request and \$uuid.response contains response to that request"
for req_dump_filename in $AREX_RUN_DIR/demultiplex/*.request; do
  grep '^GET /' $req_dump_filename || exit_code=1
  # $uuid.request ~ $uuid.response
  res_dump_filename=$(echo $req_dump_filename | sed s:request$:response:)
  grep 'HTTP/1.1 200 OK' $res_dump_filename || exit_code=1
  tail -n 1 $res_dump_filename | cut -c -100
done

exit $exit_code
