exit_code=0

htpasswd -bc $AREX_RUN_DIR/password-file john StrongPassword
echo 'Login unsuccessfull, try again.' > $AREX_DOCUMENT_ROOT/login.html
echo 'Logged in!'                      > $AREX_DOCUMENT_ROOT/success.html
mkdir -p $AREX_DOCUMENT_ROOT/private/
echo 'Only for authorized stuff!'      > $AREX_DOCUMENT_ROOT/private/index.html

echo "[1] authorized access"
cookie=$(curl -s -i --data 'userid_field=john&password_field=StrongPassword' http://localhost:$AREX_RUN_PORT/dologin.html \
           | grep 'Set-Cookie:' | sed 's:Set-::' | tr -d '\r')
# just informative output of the cookie
echo $cookie
curl -s -H "$cookie" http://localhost:$AREX_RUN_PORT/private/ \
  | grep 'Only for authorized stuff!' || exit_code=1

echo "[2] unauthorized access"
curl -s -H "Cookie: malformed" --location http://localhost:$AREX_RUN_PORT/private/ \
  | grep 'Login unsuccessfull, try again.' || exit_code=2

exit $exit_code

