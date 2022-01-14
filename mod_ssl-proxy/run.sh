exit_code=0

echo 'Test SSL via Proxy' > $AREX_DOCUMENT_ROOT/index.html

echo "[1] access trough https allowed"
curl -s --cacert $AREX_RUN_DIR/ca/my.crt --resolve "frontend.su.se:$AREX_PORT1:127.0.0.1" https://frontend.su.se:$AREX_PORT1/ \
    | grep 'Test SSL via Proxy' || exit_code=1
echo "[2] show logs"
echo ----- from CURL log
curl -v -s --cacert $AREX_RUN_DIR/ca/my.crt --resolve "frontend.su.se:$AREX_PORT1:127.0.0.1" https://frontend.su.se:$AREX_PORT1/ \
    2>&1 | grep 'TLS handshake' || exit_code=2
echo ----- from FRONTEND log
grep 'backend.su.se' $AREX_RUN_DIR/error_log-frontend || exit_code=2
echo ----- from BACKEND log
grep 'Server name not provided via TLS extension' $AREX_RUN_DIR/error_log-backend || exit_code=2

exit $exit_code
