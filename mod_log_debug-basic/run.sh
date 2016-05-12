exit_code=0

echo "[1] log of request and internal request after rewrite"
mkdir -p $AREX_DOCUMENT_ROOT/foo/
echo 'Welcome!' > $AREX_DOCUMENT_ROOT/foo/welcome.html
curl -s http://localhost:$AREX_PORT/foo/bar.html > /dev/null 
grep 'has been requested' $AREX_RUN_DIR/error_log || exit_code=1

exit $exit_code

