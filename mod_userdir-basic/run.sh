exit_code=0

echo "[1] demonstrate public_html for $USER user"
mkdir -p ~/public_html
echo "hello from $USER user" > ~/public_html/index.html
curl -s http://localhost:$AREX_RUN_PORT/~$USER/ | grep "hello from $USER user" || exit_code=1

for u in root user1 user2; do
  mkdir -p $AREX_RUN_DIR/users/$u/my_html
  echo "hello from $u" > $AREX_RUN_DIR/users/$u/my_html/index.html
done

echo "[2] public_html on another prefix, UserDir enabled for user"
curl -s http://localhost:$AREX_RUN_PORT1/~user1/ | grep 'hello from user1' || exit_code=2
echo "[3] public_html on another prefix,  UserDir disabled for user"
curl -s http://localhost:$AREX_RUN_PORT1/~root/ | grep '404 Not Found' || exit_code=3
echo "[4] public_html on another prefix,  UserDir enabled user, but forbidden by .htaccess"
printf "$AREX_DENY_FROM_ALL" > $AREX_RUN_DIR/users/user2/my_html/.htaccess
curl -s http://localhost:$AREX_RUN_PORT1/~user2/ | grep 'hello from user2' && exit_code=4

exit $exit_code
