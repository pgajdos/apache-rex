exit_code=0

echo "[1] ProxyErrorOverride is off by default"
curl -s http://localhost:$AREX_RUN_PORT2/ | grep 'Virtual Host Handling of 404' || exit_code=1

echo "[2] if ProxyErrorOverride is on, then proxy handles the error"
curl -s http://localhost:$AREX_RUN_PORT3/ | grep 'Proxy handling of 404' || exit_code=2

exit $exit_code
