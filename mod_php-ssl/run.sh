exit_code=0

echo "[1] access trough https to php script"
cp welcome.php $AREX_DOCUMENT_ROOT
curl -s --cacert $AREX_RUN_DIR/ca/my.crt --resolve "aserver.suse.cz:$AREX_PORT:127.0.0.1" https://aserver.suse.cz:$AREX_PORT/welcome.php \
    | grep 'HELLO FROM PHP MODULE, USING SSL' || exit_code=1

echo "[2] use php openssl extension"
cp encrypt.php $AREX_DOCUMENT_ROOT
curl -s --cacert $AREX_RUN_DIR/ca/my.crt --resolve "aserver.suse.cz:$AREX_PORT:127.0.0.1" https://aserver.suse.cz:$AREX_PORT/encrypt.php \
    | grep 'message to be encrypted' || exit_code=1

exit $exit_code
