exit_code=0

echo 'Test SSL, restricted area' > $AREX_DOCUMENT_ROOT/index.html

echo "[1] access for not authentificated client disallowed"
curl --cacert test-ca.crt --resolve "test:$AREX_PORT:127.0.0.1" https://test:$AREX_PORT/ 2>&1 | grep 'handshake failure' || exit_code=1

echo "[2] client verified"
curl -s --cacert test-ca.crt --cert client.crt --key client.key  --resolve "test:$AREX_PORT:127.0.0.1" https://test:$AREX_PORT/ | grep 'Test SSL' || exit_code=2
 
exit $exit_code
