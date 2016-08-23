exit_code=0

echo "[1] try telnet echo (as advised in https://httpd.apache.org/docs/trunk/mod/mod_echo.html)"
{ echo 'repeat this please'; sleep 1; } | telnet localhost $AREX_PORT 2>/dev/null \
  | grep repeat || exit_code=1

echo "[2] try echo also request created by curl"
curl -s -H 'Note: this will be repeated, too'  http://localhost:$AREX_PORT/?var=repeat_this \
  | grep 'repeat' || exit_code=2

exit $exit_code
