exit_code=0
icontent='site index'
sizeof_icontent=$(echo $icontent | wc -c)
curl -s http://localhost:$AREX_PORT/ > /dev/null
echo $icontent > $AREX_DOCUMENT_ROOT/index.html
curl -s http://localhost:$AREX_PORT/ > /dev/null
echo ERROR LOG:
cat $AREX_RUN_DIR/error_log
echo
echo REQUEST LOG:
cat $AREX_RUN_DIR/requests
echo
echo RESPONSE LOG:
cat $AREX_RUN_DIR/responses
echo

echo "[1] 404 logs"
if [ $AREX_APACHE_VERSION -ge 20400 ]; then
  # gather request error_log id
  request_error_log_id=$(grep 'Attempt to serve directory' $AREX_RUN_DIR/error_log | sed 's:^\([^|]*\)|.*:\1:')
  echo "REQUEST LOG ID: $request_error_log_id, related logs:"
  grep $request_error_log_id $AREX_RUN_DIR/{error_log,requests,responses}
else
  grep '\[url: /\]'      $AREX_RUN_DIR/requests  || exit_code=1
  grep '\[status: 404\]' $AREX_RUN_DIR/responses || exit_code=1
fi

echo
echo "[2] 200 logs"
if [ $AREX_APACHE_VERSION -ge 20400 ]; then
  # this will not get error_log id, as it generates no log entry in error_log
  # for 'info' LogLevel; in case of 'debug' it would get one
  request_error_log_id='-'
  echo "REQUEST LOG ID: $request_error_log_id, related logs:"
  grep "^$request_error_log_id|" $AREX_RUN_DIR/{requests,responses}
fi
grep '\[url: /index.html\]'       $AREX_RUN_DIR/requests  || exit_code=2
grep '\[status: 200\] \[size: 11\]' $AREX_RUN_DIR/responses || exit_code=2

exit $exit_code
