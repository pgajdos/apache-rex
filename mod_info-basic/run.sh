exit_code=0

echo "[1] string 'Apache Server Information' found in /server-info/"
curl -s -q http://localhost:$AREX_RUN_PORT/server-info/ | grep 'Apache Server Information' || exit_code=1

echo "[2] string 'mod_info.c' found in /server-info/"
curl -s -q http://localhost:$AREX_RUN_PORT/server-info/ | grep 'Module Name.*mod_info.c' || exit_code=2

echo "[3] string 'mod_ssl.c' found in /server-info/"
curl -s -q http://localhost:$AREX_RUN_PORT/server-info/ | grep 'Module Name.*mod_ssl.c' || exit_code=3

exit $exit_code

