exit_code=0

htpasswd -bc $AREX_RUN_DIR/htpasswd john StrongPassword
echo 'Secret DATA' > $AREX_DOCUMENT_ROOT/index.html

echo "[1] access granted with correct username and correct password"
curl -u john:StrongPassword -s http://localhost:$AREX_PORT/ | grep 'Secret DATA' || exit_code=1
echo "[2] access denied with correct username but incorrect password"
curl -u john:WrongPassword -s http://localhost:$AREX_PORT/ | grep '401.*uthoriz' || exit_code=2
echo "[3] access denied for incorrect username"
curl -u dave:StrongPassword -s http://localhost:$AREX_PORT/ | grep '401.*uthoriz' || exit_code=3

exit $exit_code
