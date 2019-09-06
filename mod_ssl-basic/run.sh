exit_code=0

echo 'Test SSL' > $AREX_DOCUMENT_ROOT/index.html

echo "[1] access trough https allowed"
curl -s --cacert $AREX_RUN_DIR/ca/my.crt --resolve "aserver.suse.cz:$AREX_PORT:127.0.0.1" https://aserver.suse.cz:$AREX_PORT/ \
    | grep 'Test SSL' || exit_code=1

echo "[2] access trough http disallowed"
curl -s --cacert $AREX_RUN_DIR/ca/my.crt --resolve "aserver.suse.cz:$AREX_PORT:127.0.0.1" http://aserver.suse.cz:$AREX_PORT/ \
    | grep '400 Bad Request' || exit_code=2

echo "[3] access to the same address under different name not allowed"
curl -v -s --cacert $AREX_RUN_DIR/ca/my.crt --resolve "test.suse.cz:$AREX_PORT:127.0.0.1" https://test.suse.cz:$AREX_PORT/ \
    2>&1 | grep 'does not match target host name' || exit_code=3

echo "[4] show protocol used by default"
curl -v -s --cacert $AREX_RUN_DIR/ca/my.crt --resolve "aserver.suse.cz:$AREX_PORT:127.0.0.1" https://aserver.suse.cz:$AREX_PORT/ \
    2>&1 | grep 'TLS handshake' || exit_code=4

exit $exit_code
