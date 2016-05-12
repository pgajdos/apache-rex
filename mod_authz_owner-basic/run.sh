exit_code=0

echo "user $AREX_USER secret" > $AREX_DOCUMENT_ROOT/$AREX_USER.html
mkdir -p $AREX_DOCUMENT_ROOT/common/
echo "group $AREX_GROUP secret" > $AREX_DOCUMENT_ROOT/common/$AREX_GROUP.html

htpasswd -bc $AREX_RUN_DIR/htpasswd $AREX_USER  StrongPassword
htpasswd -b  $AREX_RUN_DIR/htpasswd bob         bobsStrongPassword
htpasswd -b  $AREX_RUN_DIR/htpasswd nobody      nobodyPassword
echo

cat << EOF > $AREX_RUN_DIR/htgroup
$AREX_GROUP:   bob $AREX_USER
nogroup:  nobody
EOF

echo "[1] access allowed for owner"
curl -s -u $AREX_USER:StrongPassword   http://localhost:$AREX_PORT/$AREX_USER.html | grep "user $AREX_USER secret"  || exit_code=1
echo "[2] access denied for non owner, even in the same group"
curl -s -u bob:bobsStrongPassword http://localhost:$AREX_PORT/$AREX_USER.html | grep '401.*uthoriz' || exit_code=2
echo "[3] access allowed for group member"
curl -s -u bob:bobsStrongPassword http://localhost:$AREX_PORT/common/$AREX_GROUP.html | grep "group $AREX_GROUP secret" || exit_code=3
echo "[4] access denied for non group member"
curl -s -u nobody:nobodyPassword  http://localhost:$AREX_PORT/common/$AREX_GROUP.html | grep '401.*uthoriz' || exit_code=4

exit $exit_code
