exit_code=0

echo -n 'index page' > $AREX_DOCUMENT_ROOT/index.html
mkdir -p $AREX_DOCUMENT_ROOT/forbidden
echo 'you can not read this' > $AREX_DOCUMENT_ROOT/forbidden/hidden.html
chmod 000 $AREX_DOCUMENT_ROOT/forbidden

echo "[1] example-handler is invoked"
# However, MD5 seems to be incorrect (compared with md5sum).
curl -s http://localhost:$AREX_PORT/index.html.sum \
  | grep 'MD5' || exit_code=1

echo "[2] example-handler is NOT invoked"
curl -s http://localhost:$AREX_PORT/index.html \
  | grep 'index page' || exit_code=2

echo "[3] example-handler is invoked with query string parameter"
# However, SHA1 seems to be incorrect (compared with md5sum).
curl -s http://localhost:$AREX_PORT/index.html.sum?digest=sha1 \
  | grep -a 'SHA1' || exit_code=3

echo "[4] example-handler on not existing file"
curl -s http://localhost:$AREX_PORT/not_existing.html.sum?digest=md5 \
  | grep '<title>404' || exit_code=4

echo "[5] example-handler on hidden file"
curl -s http://localhost:$AREX_PORT/forbidden/hidden.html.sum \
  | grep '<title>403' || exit_code=5

# to allow soft cleanup
chmod 755 $AREX_DOCUMENT_ROOT/forbidden

exit $exit_code
