exit_code=0

echo "[1] allow access depending on a file existance"
mkdir -p $AREX_DOCUMENT_ROOT/dir
echo "main index" > $AREX_DOCUMENT_ROOT/index.html
echo "dir index" > $AREX_DOCUMENT_ROOT/dir/index.html
touch $AREX_DOCUMENT_ROOT/forbid
curl -s http://localhost:$AREX_PORT/ | grep '403 Forbidden' || exit_code=1
curl -s http://localhost:$AREX_PORT/dir/ | grep 'dir index' || exit_code=1

exit $exit_code

