exit_code=0

echo "[1] echo request body"
curl -s -X POST -d 'This is content of a request body.' http://localhost:$AREX_PORT/body-echo

exit $exit_code
