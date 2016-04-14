exit_code=0

echo 'main index' > $AREX_DOCUMENT_ROOT/index.html
cp apache_pb.png    $AREX_DOCUMENT_ROOT

echo "[1] set (different) Expires header for doc and image"
docexpires=$(curl -v http://localhost:$AREX_RUN_PORT/index.html    2>&1 | grep 'Expires' | sed 's/< Expires: //')
echo "/index.html    expires at $docexpires"
imgexpires=$(curl -v http://localhost:$AREX_RUN_PORT/apache_pb.png 2>&1 | grep 'Expires' | sed 's/< Expires: //')
echo "/apache_pb.png expires at $imgexpires"
[ "$docexpires" != "$imgexpires" ] || exit_code=1

echo "[2] set (different) max-age directive for doc and image in Cache-Control header"
docexpires=$(curl -v http://localhost:$AREX_RUN_PORT/index.html    2>&1 | grep 'max-age' | sed 's/< Cache-Control: max-age=//')
echo "/index.html    expires at $docexpires"
imgexpires=$(curl -v http://localhost:$AREX_RUN_PORT/apache_pb.png 2>&1 | grep 'max-age' | sed 's/< Cache-Control: max-age=//')
echo "/apache_pb.png expires at $imgexpires"
[ "$docexpires" != "$imgexpires" ] || exit_code=2

exit $exit_code
