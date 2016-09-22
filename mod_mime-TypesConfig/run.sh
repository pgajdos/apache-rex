exit_code=0

echo "[1] document test.tst is recognized as bar/tst"
echo 'helloworld' > $AREX_DOCUMENT_ROOT/test.tst
curl -s http://localhost:$AREX_PORT/test.tst  | grep  'HELLOWORLD' || exit_code=4

exit $exit_code
