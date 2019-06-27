exit_code=0

echo 'Test SSL' > $AREX_DOCUMENT_ROOT/index.html

echo "[1] access trough https allowed"
curl -s --cacert $AREX_RUN_DIR/ca/my.crt --resolve "gnutls.server.org:$AREX_PORT:127.0.0.1" https://gnutls.server.org:$AREX_PORT/ \
    | grep 'Test SSL' || exit_code=1

echo "[2] access trough http disallowed"
curl -s --cacert $AREX_RUN_DIR/ca/my.crt --resolve "gnutls.server.org:$AREX_PORT:127.0.0.1" http://gnutls.server.org:$AREX_PORT/ \
    | grep 'Test SSL' && exit_code=2
grep 'GnuTLS: Handshake Failed' $AREX_RUN_DIR/error_log || exit_code=2

exit $exit_code


