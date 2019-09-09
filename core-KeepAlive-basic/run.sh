exit_code=0

mkdir -p $AREX_RUN_DIR/htdocs-vh{1,2}

echo 'site index 1' > $AREX_RUN_DIR/htdocs-vh1/index.html
cp apache_pb.png      $AREX_RUN_DIR/htdocs-vh1/

echo 'site index 2' > $AREX_RUN_DIR/htdocs-vh2/index.html
cp apache_pb.png      $AREX_RUN_DIR/htdocs-vh2/

echo "[1] connection was reused when KeepAlive on"
curl -s -v http://localhost:$AREX_PORT1/ \
           http://localhost:$AREX_PORT1/apache_pb.png > $AREX_RUN_DIR/out-vh1 2>&1
grep -a 'Re-using existing connection!' $AREX_RUN_DIR/out-vh1 || exit_code=1

echo "[2] there was two connections when KeepAlive off"
curl -s -v http://localhost:$AREX_PORT2/ \
           http://localhost:$AREX_PORT2/apache_pb.png > $AREX_RUN_DIR/out-vh2 2>&1
grep -a 'Re-using existing connection'  $AREX_RUN_DIR/out-vh2 && exit_code=2

if [ $AREX_APACHE_VERSION -ge 20400 ]; then
  echo "[3] error_log containing requests to connections according"
  cat $AREX_RUN_DIR/error_log | grep 'Request [01]' | tee $AREX_RUN_DIR/requests-to-conections
  [ $(grep -c 'Request 0' $AREX_RUN_DIR/requests-to-conections) -eq 3 ] || exit_code=3
  [ $(grep -c 'Request 1' $AREX_RUN_DIR/requests-to-conections) -eq 1 ] || exit_code=3
fi

exit $exit_code
