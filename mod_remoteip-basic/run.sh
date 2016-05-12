exit_code=0

echo "[1] reading ip from custom header line"
mkdir -p $AREX_RUN_DIR/htdocs-vh1
echo 'allowed' > $AREX_RUN_DIR/htdocs-vh1/index.html
curl -s                            http://localhost:$AREX_PORT1/ | grep 'allowed'    || exit_code=1
curl -s -H "my-header-ip: 1.2.3.4" http://localhost:$AREX_PORT1/ | grep 'disallowed' || exit_code=1
curl -s -H "my-header-ip: 1.1.1.1" http://localhost:$AREX_PORT1/ | grep 'allowed'    || exit_code=1

echo "[2] reading ip from custom header line sent by proxy"
curl -s http://localhost:$AREX_PORT2/ | grep 'disallowed' || exit_code=2
curl -s http://localhost:$AREX_PORT3/ | grep 'allowed'    || exit_code=2

exit $exit_code

