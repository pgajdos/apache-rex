exit_code=0
htpasswd -bc $AREX_RUN_DIR/password-file john StrongPassword

mkdir -p $AREX_DOCUMENT_ROOT/{any,all}
echo 'content allowed for localhost OR valid-user'  > $AREX_DOCUMENT_ROOT/any/index.html
echo 'content allowed for localhost AND valid-user' > $AREX_DOCUMENT_ROOT/all/index.html

echo "[1] allowed because one of conditions are met: localhost, valid-user"
curl -s http://localhost:$AREX_PORT/any/ | grep 'content allowed for localhost OR valid-user' || exit_code=1
echo "[2] allowed because all of conditions are met: localhost, valid-user"
curl -s -u john:StrongPassword http://localhost:$AREX_PORT/all/ | grep 'content allowed for localhost AND valid-user' || exit_code=2
echo "[3] denied because valid-user is not met"
curl -s http://localhost:$AREX_PORT/all/ | grep '401 Authorization Required' || exit_code=3

exit $exit_code
