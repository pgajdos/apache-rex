# http://httpd.apache.org/docs/current/mod/mod_proxy.html#proxypass
# 'Ordering ProxyPass Directives'
exit_code=0

mkdir -p $AREX_RUN_DIR/htdocs-backend1
echo 'Backend 1' > $AREX_RUN_DIR/htdocs-backend1/index.html
mkdir -p $AREX_RUN_DIR/htdocs-backend2
echo 'Backend 2' > $AREX_RUN_DIR/htdocs-backend2/index.html
mkdir -p $AREX_RUN_DIR/htdocs-backend3
echo 'Backend 3' > $AREX_RUN_DIR/htdocs-backend3/index.html
mkdir -p $AREX_RUN_DIR/htdocs-backend4
echo 'Backend 4' > $AREX_RUN_DIR/htdocs-backend4/index.html
echo 'Frontend' > $AREX_DOCUMENT_ROOT/index.html

if [ $AREX_APACHE_VERSION -ge 20400 ]; then
  echo "[1] no ProxyPass directive matches, document is taken from the frontend server"
  curl -s http://localhost:$AREX_PORT5/          | grep 'Frontend'  || exit_code=1
  echo "[2] Location /app1/foo/ does not match, ProxyPass /app1/ wins"
  curl -s http://localhost:$AREX_PORT5/app1/     | grep 'Backend 1' || exit_code=2
  echo "[3] Location /app1/foo/ matches, have precedence over solitary ProxyPass /app1/"
  echo "    (compare with mod-proxy-ordering-ProxyPass)"
  curl -s http://localhost:$AREX_PORT5/app1/foo/ | grep 'Backend 2' || exit_code=3
  echo "[4] Location /app2/ matches"
  curl -s http://localhost:$AREX_PORT5/app2/     | grep 'Backend 4' || exit_code=4
  echo "[5] Location /app2/ matches, searching for /bar/ on localhost:@AREX_PORT4@,"
  echo "    not found"
  curl -s http://localhost:$AREX_PORT5/app2/bar/ | grep '404'       || exit_code=5
else
  echo "[1] no ProxyPass directive matches, document is taken from the frontend server"
  curl -s http://localhost:$AREX_PORT5/          | grep 'Frontend'  || exit_code=1
  echo "[2] ProxyPass /app1/ matches"
  curl -s http://localhost:$AREX_PORT5/app1/     | grep 'Backend 1' || exit_code=2
  echo "[3] solitary ProxyPass /app1/ matches, /foo/ is searched on localhost:$AREX_PORT1,"
  echo "    not found (compare with 2.4 branch)"
  curl -s http://localhost:$AREX_PORT5/app1/foo/ | grep '404'       || exit_code=3
  echo "[4] Location /app2/ matches"
  curl -s http://localhost:$AREX_PORT5/app2/     | grep 'Backend 4' || exit_code=4
  echo "[5] ProxyPass /app2/bar/ matches,"
  curl -s http://localhost:$AREX_PORT5/app2/bar/ | grep 'Backend 3' || exit_code=5
fi

exit $exit_code
