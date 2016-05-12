exit_code=0

mkdir -p $AREX_DOCUMENT_ROOT/protected/
echo 'Restricted Area Index' > $AREX_DOCUMENT_ROOT/protected/index.html

# run fcgi authenticator/authorizator via spawn-fcgi
cp authnz.pl $AREX_RUN_DIR/
chmod 755    $AREX_RUN_DIR/authnz.pl
spawn-fcgi -P $AREX_RUN_DIR/spawn-fcgi.pid -a 127.0.0.1 -p $AREX_FCGI_PORT $AREX_RUN_DIR/authnz.pl
sleep 1

echo
echo "[1] user authenticated with fcgi application"
curl -s -u brcalnik:BrcalniksPassword http://localhost:$AREX_PORT/protected/ \
  | grep 'Restricted Area Index' || exit_code=1
grep 'authenticating brcalnik' $AREX_RUN_DIR/error_log || exit_code=1

echo
echo "[2] access denied by fcgi application"
curl -s -u puskvorec:WrongPassword http://localhost:$AREX_PORT/protected/ \
  | grep '401' || exit_code=2
grep 'authenticating puskvorec' $AREX_RUN_DIR/error_log || exit_code=2
grep 'user puskvorec: authentication failure.*Password Mismatch' $AREX_RUN_DIR/error_log || exit_code=2

kill -TERM $(cat $AREX_RUN_DIR/spawn-fcgi.pid)

exit $exit_code
