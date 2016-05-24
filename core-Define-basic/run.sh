exit_code=0

echo 'site index' > $AREX_DOCUMENT_ROOT/index.html
echo 'test index' > $AREX_RUN_DIR/htdocs-test/index.html

echo "[1] Define redirects to test DocumentRoot"
curl -s http://localhost:$AREX_PORT/ | grep 'test index' || exit_code=1

exit $exit_code
