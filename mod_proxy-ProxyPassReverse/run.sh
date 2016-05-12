exit_code=0

for i in 1 2; do
  mkdir -p $AREX_RUN_DIR/htdocs-internal$i/start
  echo "reply from backend $i" > $AREX_RUN_DIR/htdocs-internal$i/start/index.html
done

echo "[1] Location: translated via ProxyPassReverse"
curl -s -i --resolve www.frontend.com:$AREX_PORT:127.0.0.1 http://www.frontend.com:$AREX_PORT/app2/ \
  | grep "Location: http://www.frontend.com:$AREX_PORT/app2/start/" || exit_code=1
curl -s --location --resolve www.frontend.com:$AREX_PORT:127.0.0.1 http://www.frontend.com:$AREX_PORT/app2/ \
  | grep 'reply from backend 2' || exit_code=1

echo "[2] Location: not translated"
curl -s -i --resolve www.frontend.com:$AREX_PORT:127.0.0.1 http://www.frontend.com:$AREX_PORT/app1/ \
  | grep "Location: http://localhost:$AREX_PORT1/start/" || exit_code=2

exit $exit_code

