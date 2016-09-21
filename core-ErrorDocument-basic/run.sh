exit_code=0

mkdir -p $AREX_DOCUMENT_ROOT/{private,errors}/
echo "<h1>forbidden for you</h1>" > $AREX_DOCUMENT_ROOT/errors/403.html
echo "private data" > $AREX_DOCUMENT_ROOT/private/index.html

echo "[1] ErrorDocument with string argument"
curl -s http://localhost:$AREX_PORT/ | grep 'the page not found' || exit_code=1

echo "[2] ErrorDocument with document file argument"
curl -s http://localhost:$AREX_PORT/private/ | grep '<h1>forbidden for you</h1>' || exit_code=2

echo "[3] ErrorDocument is not defined for this error, default taken"
curl -X NOTIMPLEMENTEDMETHOD -s http://localhost:$AREX_PORT/ | grep '501 Not Implemented\|NOTIMPLEMENTEDMETHOD' || exit_code=3

exit $exit_code

