exit_code=0

htpasswd -bc $AREX_RUN_DIR/htpasswd john StrongPassword
mkdir -p $AREX_DOCUMENT_ROOT/foo
echo 'DATA' > $AREX_DOCUMENT_ROOT/foo/index.html

echo "[1] access granted for registred user"
curl -u john:StrongPassword -s http://localhost:$AREX_RUN_PORT/foo/ | grep 'DATA' || exit_code=1
echo "[2] access granted to anonymous user"
curl -u anonymous:post@email.com -s http://localhost:$AREX_RUN_PORT/foo/ | grep 'DATA' || exit_code=2
echo "[3] email get logged"
cat $AREX_RUN_DIR/error_log | grep 'Anonymous: Passwd <post@email.com> Accepted' || exit_code=3
echo "[4] access denied when no user id given"
curl -s http://localhost:$AREX_RUN_PORT/foo/ | grep '401.*uthoriz' || exit_code=4
echo "[5] access denied when no password given"
curl -u anonymous: -s http://localhost:$AREX_RUN_PORT/foo/ | grep '401.*uthoriz' || exit_code=5
echo "[6] access denied when password is not in email format"
curl -u anonymous:password -s http://localhost:$AREX_RUN_PORT/foo/ | grep '401.*uthoriz' || exit_code=6

exit $exit_code
