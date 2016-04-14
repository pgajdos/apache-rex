exit_code=0

echo "[1] string 'Server Version: Apache' found in /server-status"
curl -s -q http://localhost:$AREX_RUN_PORT/server-status/ | grep 'Server Version: Apache' || exit_code=1

echo "[2] string 'Child Server number' found in /server-status"
curl -s -q http://localhost:$AREX_RUN_PORT/server-status/ | grep 'Child Server number' || exit_code=2

exit $exit_code
