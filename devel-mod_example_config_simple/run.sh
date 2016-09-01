exit_code=0

echo "[1] example-handler shows the configuration"
curl -s http://localhost:$AREX_PORT/example > $AREX_RUN_DIR/out

grep 'Enabled: 0'              $AREX_RUN_DIR/out || exit_code=1
grep '/different/from/default' $AREX_RUN_DIR/out || exit_code=1

exit $exit_code
