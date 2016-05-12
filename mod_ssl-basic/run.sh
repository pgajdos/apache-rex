exit_code=0

echo 'Test SSL' > $AREX_DOCUMENT_ROOT/index.html

echo "[1] access trough https allowed"
curl -s -k https://localhost:$AREX_PORT/ | grep 'Test SSL' || exit_code=1
echo "[2] access trough http disallowed"
curl -s -k http://localhost:$AREX_PORT/ | grep '400 Bad Request' || exit_code=2

exit $exit_code
