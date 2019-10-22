exit_code=0

echo 'Test SSL' > $AREX_DOCUMENT_ROOT/index.html

echo "[1] access trough https allowed"
curl -s --cacert $AREX_RUN_DIR/ca/my.crt --resolve "aserver.suse.cz:$AREX_PORT:127.0.0.1" https://aserver.suse.cz:$AREX_PORT/ \
    | grep 'Test SSL' || exit_code=1

echo "[2] error_log contains references to pkcs11"
grep 'Certificate and private key.*pkcs11:token=aserver.suse.cz-token' $AREX_RUN_DIR/error_log || exit_code=2

exit $exit_code
