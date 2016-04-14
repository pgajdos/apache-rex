exit_code=0

mkdir -p $AREX_RUN_DIR/htdocs-vh1
echo 'Virtual Host 1' > $AREX_RUN_DIR/htdocs-vh1/index.html
mkdir -p $AREX_RUN_DIR/htdocs-vh2
echo 'Virtual Host 2' > $AREX_RUN_DIR/htdocs-vh2/index.html

echo "[1] reverse proxy (ProxyPass directive, ProxyRequests off)"
curl -s http://localhost:$AREX_RUN_PORT/vh1/ | grep 'Virtual Host 1' || exit_code=1
curl -s http://localhost:$AREX_RUN_PORT/vh2/ | grep 'Virtual Host 2' || exit_code=1

echo "[2] forward proxy (ProxyRequests on) and <Proxy> directive"
# for example to http://localhost:$AREX_RUN_PORT/vh1/, it could be 
# http://localhost:$AREX_RUN_PORT1/ or  http://localhost:$AREX_RUN_PORT2/ also
curl -s --proxy http://localhost:$AREX_RUN_PORT3/ http://localhost:$AREX_RUN_PORT/vh1/ | grep 'Virtual Host 1' || exit_code=2
curl -s --proxy http://localhost:$AREX_RUN_PORT4/ http://localhost:$AREX_RUN_PORT/vh1/ | grep '403 Forbidden' || exit_code=2

exit $exit_code
