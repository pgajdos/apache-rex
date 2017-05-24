# http://httpd.apache.org/docs/current/mod/mod_proxy.html#proxypass
# 'Ordering ProxyPass Directives'
exit_code=0

mkdir -p $AREX_RUN_DIR/htdocs-backend1
echo 'Backend 1' > $AREX_RUN_DIR/htdocs-backend1/index.html
mkdir -p $AREX_RUN_DIR/htdocs-backend2
echo 'Backend 2' > $AREX_RUN_DIR/htdocs-backend2/index.html
mkdir -p $AREX_RUN_DIR/htdocs-backend3
echo 'Backend 3' > $AREX_RUN_DIR/htdocs-backend3/index.html
echo 'Frontend' > $AREX_DOCUMENT_ROOT/index.html

echo "[1] no ProxyPass directive matches, document is taken from the frontend server"
curl -s http://localhost:$AREX_PORT4/        | grep 'Frontend'  || exit_code=1
echo "[2] ProxyPass /app/1/ matches, ProxyPass /app/ is not processed"
curl -s http://localhost:$AREX_PORT4/app/1/  | grep 'Backend 1' || exit_code=2
echo "[3] ProxyPass /app/ matches"
curl -s http://localhost:$AREX_PORT4/app/    | grep 'Backend 2' || exit_code=3
echo "[4] ProxyPass /app/ matches, /2/ is searched on localhost:$AREX_PORT2, not found"
curl -s http://localhost:$AREX_PORT4/app/2/  | grep '404'       || exit_code=4

exit $exit_code
