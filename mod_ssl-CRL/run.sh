exit_code=0

echo 'Test SSL, restricted area' > $AREX_DOCUMENT_ROOT/index.html

echo "[1] client's certificate was revoked, connection refused"
curl --cacert $AREX_RUN_DIR/cert/test-ca.crt \
      --cert   $AREX_RUN_DIR/cert/test-clientA.crt \
      --key    $AREX_RUN_DIR/cert/test-clientA.key  \
      --resolve "test:$AREX_PORT:127.0.0.1" https://test:$AREX_PORT/ 2>&1 \
  | grep 'certificate revoked' || exit_code=1
grep 'certificate revoked' $AREX_RUN_DIR/error_log || exit_code=1

echo "[2] client correctly verified"
curl -s --cacert $AREX_RUN_DIR/cert/test-ca.crt \
        --cert   $AREX_RUN_DIR/cert/test-clientB.crt \
        --key    $AREX_RUN_DIR/cert/test-clientB.key  \
        --resolve "test:$AREX_PORT:127.0.0.1" https://test:$AREX_PORT/ \
  | grep 'Test SSL' || exit_code=2
 
exit $exit_code
