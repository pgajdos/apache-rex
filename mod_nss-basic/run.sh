exit_code=0

echo 'HTTPS HELLO' > $AREX_DOCUMENT_ROOT/index.html

echo "[1] access trough https"
curl -s -k https://localhost:$AREX_PORT/ | grep 'HTTPS HELLO' || exit_code=1

exit $exit_code
