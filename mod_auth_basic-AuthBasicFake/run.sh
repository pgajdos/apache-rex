exit_code=0

mkdir -p $AREX_RUN_DIR/backend/htdocs/
htpasswd -bc $AREX_RUN_DIR/backend/htpasswd john StrongPassword
echo 'Secret DATA' > $AREX_RUN_DIR/backend/htdocs/index.html

echo "[1] access backend directly, without password"
curl -s http://localhost:$AREX_PORT1/                        | grep '401.*uthoriz' || exit_code=1
echo "[2] access backend directly, with correct password"
curl -u john:StrongPassword -s http://localhost:$AREX_PORT1/ | grep 'Secret DATA' || exit_code=2
echo "[3] access frontend, uses AuthBasicFake to access backend"
curl -s http://localhost:$AREX_PORT/app/                     | grep 'Secret DATA' || exit_code=2


exit $exit_code
