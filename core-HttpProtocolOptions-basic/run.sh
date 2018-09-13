exit_code=0

echo 'virtual hosts common index' > $AREX_DOCUMENT_ROOT/index.html

echo "[1] correct request even for Strict"
rq="GET / HTTP/1.0\r\n\r\n"
printf "$rq" | nc -q -1 localhost $AREX_PORT1 | grep 'HTTP/1.1 200 OK' || exit_code=1
echo

echo "[2] incorrect request for both Strict and Unsafe"
rq="GET\r/ HTTP/1.0\r\n\r\n"
printf "$rq" | nc -q -1 localhost 60081 | grep 'HTTP/1.1 400 Bad Request' || exit_code=2
printf "$rq" | nc -q -1 localhost 60082 | grep 'HTTP/1.1 400 Bad Request' || exit_code=2

echo "[3] incorrect request for Strict, correct for Unsafe"
rq="GET / HTTP/1.0\n\n"
printf "$rq" | nc -q -1 localhost $AREX_PORT1 | grep 'HTTP/1.1 400 Bad Request' || exit_code=3
printf "$rq" | nc -q -1 localhost $AREX_PORT2 | grep 'HTTP/1.1 200 OK'          || exit_code=3

exit $exit_code
