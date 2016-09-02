exit_code=0

echo 'index page' > $AREX_DOCUMENT_ROOT/index.html
curl -s -H 'Cache: no-cache' http://localhost:$AREX_PORT/ > $AREX_RUN_DIR/out

echo "[1] our handler prints the headers"
grep 'Host: localhost:60080' $AREX_RUN_DIR/out || exit_code=1
grep 'Cache: no-cache'       $AREX_RUN_DIR/out || exit_code=1

echo "[2] default handlers for *.html are overriden, though"
grep 'index page'            $AREX_RUN_DIR/out && exit_code=2

exit $exit_code
