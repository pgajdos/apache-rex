exit_code=0

htpasswd -bc $AREX_RUN_DIR/password-file john StrongPassword
echo 'Login unsuccessfull, try again.' > $AREX_DOCUMENT_ROOT/login.html
echo 'Logged in!'                      > $AREX_DOCUMENT_ROOT/success.html

echo "[1] successful login"
curl -s --location --data 'userid_field=john&password_field=StrongPassword' http://localhost:$AREX_RUN_PORT/dologin.html \
 | grep 'Logged in!' || exit_code=1
echo "[2] unsuccessful login (wrong password)"
curl -s --location --data 'userid_field=john&password_field=WrongPassword' http://localhost:$AREX_RUN_PORT/dologin.html \
 | grep 'Login unsuccessfull, try again.' || exit_code=2
echo "[3] unsuccessful login (no password)"
curl -s --location --data 'userid_field=john' http://localhost:$AREX_RUN_PORT/dologin.html \
 | grep 'Login unsuccessfull, try again.' || exit_code=3
echo "[4] unsuccessful login (not registered user)"
curl -s --location --data 'userid_field=puskvorec&password_field=puskvorecsPassword' http://localhost:$AREX_RUN_PORT/dologin.html \
 | grep 'Login unsuccessfull, try again.' || exit_code=4
echo "[5] unsuccessful login (no credetials)"
curl -s --location http://localhost:$AREX_RUN_PORT/dologin.html \
 | grep 'Login unsuccessfull, try again.' || exit_code=5

exit $exit_code
