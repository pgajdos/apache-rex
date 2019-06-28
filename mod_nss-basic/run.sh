exit_code=0

echo 'HTTPS HELLO' > $AREX_DOCUMENT_ROOT/index.html

echo "[1] access trough https"
curl -k https://localhost:$AREX_PORT/

exit $exit_code
