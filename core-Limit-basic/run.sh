exit_code=0

echo 'main index' > $AREX_DOCUMENT_ROOT/index.html

echo "[1] GET allowed, others are not"
curl -s -X GET  http://localhost:$AREX_PORT/ | grep 'main index'    || exit_code=1
curl -s -X POST http://localhost:$AREX_PORT/ | grep '403 Forbidden' || exit_code=1

exit $exit_code
