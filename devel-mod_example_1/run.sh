exit_code=0

echo 'index page' > $AREX_DOCUMENT_ROOT/index.html

echo "[1] example-handler is invoked"
curl http://localhost:$AREX_PORT/hello

echo "[2] example-handler is NOT invoked"
curl http://localhost:$AREX_PORT/

exit $exit_code
