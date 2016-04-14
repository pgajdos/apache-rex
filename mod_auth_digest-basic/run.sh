exit_code=0

echo 'Secret DATA' > $AREX_DOCUMENT_ROOT/index.html

echo "[1] access granted with correct username and correct password"
curl --digest -u john:StrongPassword -s http://localhost:$AREX_RUN_PORT/ | grep 'Secret DATA' || exit_code=1
echo "[2] access denied with correct username but incorrect password"
curl --digest -u john:WrongPassword -s http://localhost:$AREX_RUN_PORT/ | grep '401.*uthoriz' || exit_code=2
echo "[3] access denied for incorrect username"
curl --digest -u dave:StrongPassword -s http://localhost:$AREX_RUN_PORT/ | grep '401.*uthoriz' || exit_code=3

exit $exit_code
