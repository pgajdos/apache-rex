exit_code=0

echo "[1] correct localhost access"
echo 'It works!' > $AREX_DOCUMENT_ROOT/index.html
curl -s http://localhost:$AREX_PORT/ | grep 'It works!' || exit_code=1

echo "[2] forbidden localhost access"
mkdir -p $AREX_DOCUMENT_ROOT/foo
echo 'It works from subdir!' > $AREX_DOCUMENT_ROOT/foo/index.html
curl -s http://localhost:$AREX_PORT/foo | grep '403 Forbidden' || exit_code=2

exit $exit_code

