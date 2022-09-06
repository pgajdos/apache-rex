exit_code=0

mkdir -p $AREX_RUN_DIR/htdocs-vh1
echo 'Virtual Host 1' > $AREX_RUN_DIR/htdocs-vh1/index.html
mkdir -p $AREX_RUN_DIR/htdocs-vh2
echo 'Virtual Host 2' > $AREX_RUN_DIR/htdocs-vh2/index.html

echo "[1] reverse proxy, Connection: without hop-by-hop headers"
curl -s http://localhost:$AREX_PORT/vh1/ > /dev/null
grep "X-Forwarded" $AREX_RUN_DIR/error_log-vh1 || exit_code=1

echo "[2] reverse proxy, Connection: with hop-by-hop headers"
curl -s -H "Connection: close, X-Forwarded-For, X-Forwarded-Host, X-Forwarded-Server" \
  http://localhost:$AREX_PORT/vh2/ > /dev/null
grep "X-Forwarded" $AREX_RUN_DIR/error_log-vh2 || exit_code=2

exit $exit_code
