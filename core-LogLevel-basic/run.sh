exit_code=0

mkdir $AREX_DOCUMENT_ROOT/no-problem/
echo 'index' > $AREX_DOCUMENT_ROOT/no-problem/index.html

echo "[1] LogLevel setting depending on %{REMOTE_ADDR} and location"
curl -s http://localhost:$AREX_PORT/problem/ > /dev/null
curl -s http://localhost:$AREX_PORT/no-problem/ > /dev/null
if [ $AREX_APACHE_VERSION -ge 20400 ]; then
  echo 'trace3 in both requests'
  grep 'http:trace3.*Response' $AREX_RUN_DIR/error_log | tee $AREX_RUN_DIR/trace3-response.txt
  [ $(cat $AREX_RUN_DIR/trace3-response.txt | wc -l) -eq 2 ] || exit_code=1
  echo 'trace4 in first only'
  grep 'http:trace4.*Content-Length' $AREX_RUN_DIR/error_log | tee $AREX_RUN_DIR/trace4-content-length.txt
  [ $(cat $AREX_RUN_DIR/trace4-content-length.txt | wc -l) -eq 1 ] || exit_code=1
else
  grep '\[debug\]' $AREX_RUN_DIR/error_log || exit_code=1
fi

exit $exit_code

