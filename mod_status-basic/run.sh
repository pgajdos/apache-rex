exit_code=0

echo "[1] string 'Apache Server Status' found in /server-status/"
curl -s -q http://localhost:$AREX_RUN_PORT/server-status/ | grep 'Apache Server Status' || exit_code=1

echo "[2] string 'Server Version: Apache' found in /server-status/"
curl -s -q http://localhost:$AREX_RUN_PORT/server-status/ | grep 'Server Version: Apache' || exit_code=2

exit $exit_code
