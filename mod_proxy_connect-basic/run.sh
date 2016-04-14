exit_code=0

mkdir -p $AREX_RUN_DIR/htdocs-backend
echo 'secure main index' > $AREX_RUN_DIR/htdocs-backend/index.html


echo "[1] exhibit CONNECT method"
curl -s -k --proxy localhost:$AREX_RUN_PORT2 https://localhost:$AREX_RUN_PORT1/ \
  | grep 'secure main index' || exit_code=1

echo "[2] CONNECT method disallowed for port not allowed by AllowCONNECT"
curl -k    --proxy localhost:$AREX_RUN_PORT3 https://localhost:$AREX_RUN_PORT1/ 2>&1 \
  | grep 'Received HTTP code 403 from proxy after CONNECT' || exit_code=2

exit $exit_code
