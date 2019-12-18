exit_code=0

# secret token
SECRET='secret'

mkdir -p $AREX_DOCUMENT_ROOT/{users,admin}
echo 'space for users' > $AREX_DOCUMENT_ROOT/users/index.html
echo 'space for admin' > $AREX_DOCUMENT_ROOT/admin/index.html

echo "[1] access for $USER to /users/ is allowed ($AREX_USER:$AREX_GROUP owner, $AREX_GROUP required)"
# dummy_auth allows for user == pass; 
curl -u $USER:$USER -s http://localhost:$AREX_PORT/users/ | grep 'space for users' || exit_code=1

echo "[2] access for not existing wilma to /users/ is disallowed ($AREX_USER:$AREX_GROUP owner, $AREX_GROUP required)"
curl -u wilma:wilma -s http://localhost:$AREX_PORT/users/ | grep '401'             || exit_code=2

echo "[3] access to $USER to /admin/ is disallowed ($AREX_USER:$AREX_GROUP owner, but admin group required)"
curl -u $USER:$USER -s http://localhost:$AREX_PORT/admin/ | grep '401'             || exit_code=3

exit $exit_code
