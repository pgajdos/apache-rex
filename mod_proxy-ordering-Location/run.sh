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

# In contrast to ProxyPass (see mod_proxy-ordering-ProxyPass) 
# <Location> seem to have different behaviour in 2.2 and 2.4 branch.
# In 2.2, it looks the same like ProxyPass.

if [ $AREX_APACHE_VERSION -ge 20400 ]; then
  echo "[1] no ProxyPass directive matches, document is taken from the frontend server"
  curl -s http://localhost:$AREX_PORT4/        | grep 'Frontend'   || exit_code=1
  echo "[2] Location /app/ matches, /1/ is searched on localhost:$AREX_PORT2, not found"
  curl -s http://localhost:$AREX_PORT4/app/1/  | grep '404'        || exit_code=2
  echo "[3] Location /app/ matches"
  curl -s http://localhost:$AREX_PORT4/app/    | grep 'Backend 2'  || exit_code=3
  echo "[4] Location /app/2/ matches, Location /app/ is not processed"
  curl -s http://localhost:$AREX_PORT4/app/2/  | grep 'Backend 3'  || exit_code=4
else
  echo "[1] no ProxyPass directive matches, document is taken from the frontend server"
  curl -s http://localhost:$AREX_PORT4/        | grep 'Frontend'   || exit_code=1
  echo "[2] Location /app/1/ matches, Location /app/ is not processed"
  curl -s http://localhost:$AREX_PORT4/app/1/  | grep 'Backend 1'  || exit_code=2
  echo "[3] Location /app/ matches"
  curl -s http://localhost:$AREX_PORT4/app/    | grep 'Backend 2'  || exit_code=3
  echo "[4] Location /app/ matches, /2/ is searched on localhost:$AREX_PORT2, not found"
  curl -s http://localhost:$AREX_PORT4/app/2/  | grep '404'        || exit_code=4
fi

exit $exit_code
