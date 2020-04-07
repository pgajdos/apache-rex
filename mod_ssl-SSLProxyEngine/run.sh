exit_code=0

mkdir -p $AREX_DOCUMENT_ROOT/backend
echo "ssl proxy hello"  > $AREX_DOCUMENT_ROOT/backend/index.html

echo "[1] http to frontend, https to backend"
curl -s http://localhost:$AREX_PORT2/app-ssl | grep 'ssl proxy hello' || exit_code=1
echo "[2] https to frontend, https to backend"
curl -s --cacert $AREX_RUN_DIR/ca/my.crt --resolve "frontend.suse.de:$AREX_PORT3:127.0.0.1" https://frontend.suse.de:$AREX_PORT3/app-ssl \
  | grep 'ssl proxy hello'  || exit_code=2

exit $exit_code

