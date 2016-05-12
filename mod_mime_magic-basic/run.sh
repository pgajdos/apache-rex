exit_code=0

mkdir -p $AREX_DOCUMENT_ROOT/img
cp apache_pb.* $AREX_DOCUMENT_ROOT/img

echo "[1] mime_magic neccessary for custom mime"
# picked by mod_mime
curl -s -i http://localhost:$AREX_PORT/img/apache_pb.png   | grep -a Content-Type \
  | grep 'image/png'   || exit_code=1
# picked by mod_mime
curl -s -i http://localhost:$AREX_PORT/img/apache_pb.gif   | grep -a Content-Type \
  | grep 'image/gif'   || exit_code=1
# mod_mime_magic neccesary
curl -s -i http://localhost:$AREX_PORT/img/apache_pb.myimg | grep Content-Type \
  | grep 'image/myimg' || exit_code=1

exit $exit_code
