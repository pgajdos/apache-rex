exit_code=0

echo "[1] example-handler shows the configuration contextually"
echo "Getting configuration:"
echo "URI: /a"
curl -s http://localhost:$AREX_PORT/a     | tee $AREX_RUN_DIR/out-a
echo "URI: /a/b"
curl -s http://localhost:$AREX_PORT/a/b   | tee $AREX_RUN_DIR/out-a-b
echo "URI: /a/b/c"
curl -s http://localhost:$AREX_PORT/a/b/c | tee $AREX_RUN_DIR/out-a-b-c
echo
echo 'Testing output:'
grep 'Path: /foo/bar'     $AREX_RUN_DIR/out-a     || exit_code=1
grep 'Enabled: 1'         $AREX_RUN_DIR/out-a-b   || exit_code=1
grep 'TypeOfAction: 11'   $AREX_RUN_DIR/out-a-b   || exit_code=1
grep 'Path: /foo/bar/baz' $AREX_RUN_DIR/out-a-b-c || exit_code=1
grep 'TypeOfAction: 12'   $AREX_RUN_DIR/out-a-b-c || exit_code=1

exit $exit_code
