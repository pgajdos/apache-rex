exit_code=0

echo 'index page' > $AREX_DOCUMENT_ROOT/index.html

echo "[1] example-handler is invoked"
curl -s http://localhost:$AREX_PORT/hello | grep 'Hello, world!' || exit_code=1

echo "[2] example-handler is NOT invoked"
curl -s http://localhost:$AREX_PORT/      | grep 'index page'    || exit_code=2

exit $exit_code
