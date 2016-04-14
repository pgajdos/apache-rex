exit_code=0

htpasswd -bc $AREX_RUN_DIR/myhtpasswd john_doe StrongPassword
echo 'private area index' > $AREX_DOCUMENT_ROOT/index.html

echo "[1] access denied when user agent address is not ::1 and user was not authenticated"
curl -s http://127.0.0.1:$AREX_RUN_PORT/ | grep '401 Unauthorized' || exit_code=1

echo "[2] access allowed for ::1 user agent address"
curl -s http://::1:$AREX_RUN_PORT/ | grep 'private area index' || exit_code=2

echo "[3] access allowed for authenticated user"
curl -s -u john_doe:StrongPassword http://127.0.0.1:$AREX_RUN_PORT/ | grep 'private area index' || exit_code=3

exit $exit_code
