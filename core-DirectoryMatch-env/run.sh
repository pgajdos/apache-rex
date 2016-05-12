exit_code=0

mkdir -p $AREX_RUN_DIR/users/{john,puskvorec}/my_html/
echo 'content allowed only for john'  > $AREX_RUN_DIR/users/john/my_html/index.html
echo 'content allowed only for puskvorec' > $AREX_RUN_DIR/users/puskvorec/my_html/index.html

htpasswd -bc $AREX_RUN_DIR/password-file john       StrongPassword
htpasswd -b  $AREX_RUN_DIR/password-file puskvorec  pStrongPassword
echo

echo "[1] disallowed for anonymous"
curl -s                              http://localhost:$AREX_PORT/~john/ \
  | grep '401.*uthoriz' || exit_code=1

echo "[2] allowed for authenticated owner"
curl -s -u john:StrongPassword       http://localhost:$AREX_PORT/~john/ \
  | grep 'content allowed only for john' || exit_code=2

echo "[3] allowed for authenticated owner"
curl -s -u puskvorec:pStrongPassword http://localhost:$AREX_PORT/~puskvorec/ \
  | grep 'content allowed only for puskvorec' || exit_code=3

echo "[4] disallowed for authenticated non-owner"
curl -s -u john:StrongPassword       http://localhost:$AREX_PORT/~puskvorec/ \
  | grep '401.*uthoriz' || exit_code=4

exit $exit_code
