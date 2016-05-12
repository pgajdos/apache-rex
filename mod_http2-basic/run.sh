exit_code=0

for i in 1 2 3 4; do
  mkdir -p $AREX_DOCUMENT_ROOT/vh$i
  echo "sample text virtual host $i" > $AREX_DOCUMENT_ROOT/vh$i/index.html
done

echo "[1] https: server supports http2, client wants it"
curl -s -v --http2    -k https://localhost:$AREX_PORT1/vh1/ 2>&1 | grep 'Using HTTP2' || exit_code=1
echo "[2] https: server supports http2, client does not want it"
curl -s -v --http1.1  -k https://localhost:$AREX_PORT1/vh1/ 2>&1 | grep 'Using HTTP2' && exit_code=2
echo "[3] https: server does not support http2, client wants it"
curl -s -v --http2    -k https://localhost:$AREX_PORT2/vh2/ 2>&1 | grep 'Using HTTP2' && exit_code=3
echo "[4] http: server does not support http2, client wants it"
curl -s -v --http2       http://localhost:$AREX_PORT3/vh3/  2>&1 | grep 'Using HTTP2' && exit_code=4
echo "[5] http: server supports http2, client does not want it"
curl -s -v --http1.1     http://localhost:$AREX_PORT3/vh3/  2>&1 | grep 'Using HTTP2' && exit_code=5
echo "[6] http: server supports http2, client wants it"
curl -s -v --http2       http://localhost:$AREX_PORT4/vh4/  2>&1 | grep 'Using HTTP2' || exit_code=6

exit $exit_code

