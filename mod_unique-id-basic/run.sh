exit_code=0

echo "[1] UNIQUE_ID is set to '[A-Za-z0-9@-]*' string"
echo 'main index' > $AREX_DOCUMENT_ROOT/index.html
curl -s http://localhost:$AREX_PORT/ > /dev/null
grep '^[A-Za-z0-9@-]* .*' $AREX_RUN_DIR/access.log || exit_code=1

exit $exit_code
