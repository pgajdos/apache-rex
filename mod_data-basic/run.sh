exit_code=0

mkdir -p $AREX_DOCUMENT_ROOT/data/images
cp apache_pb.png $AREX_DOCUMENT_ROOT/data/images

# mime module needed for mimetype here
echo "[1] png image is encoded into base64"
curl -s http://localhost:$AREX_RUN_PORT/data/images/apache_pb.png | cut -c -50 | grep 'data:image/png;base64' || exit_code=1

exit $exit_code

