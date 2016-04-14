exit_code=0

echo 'main index' > $AREX_DOCUMENT_ROOT/index.html
mkdir -p $AREX_DOCUMENT_ROOT/pub
echo 'pub index'  > $AREX_DOCUMENT_ROOT/pub/index.html

echo "[1] show how policy enforces Content-Type response header to be present"
# mod_mime is not included, so Content-Type is missing
curl -s http://localhost:$AREX_RUN_PORT/index.html | grep '502 Bad Gateway' || exit_code=1
curl -s http://localhost:$AREX_RUN_PORT/pub/index.html | grep 'pub index' || exit_code=1

exit $exit_code

