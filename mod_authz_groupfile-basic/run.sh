exit_code=0

mkdir -p $AREX_DOCUMENT_ROOT/admin
echo 'user content' > $AREX_DOCUMENT_ROOT/index.html
echo 'admin content' > $AREX_DOCUMENT_ROOT/admin/index.html

htpasswd -bc $AREX_RUN_DIR/htpasswd bob bobsStrongPassword
htpasswd -b  $AREX_RUN_DIR/htpasswd joe joesStrongPassword
htpasswd -b  $AREX_RUN_DIR/htpasswd ann annsStrongPassword

cat << EOF > $AREX_RUN_DIR/htgroup
users: bob joe ann
admin: ann
EOF

echo "[1] access allowed to user content for ordinary user"
curl -s -u bob:bobsStrongPassword http://localhost:$AREX_RUN_PORT/       | grep 'user content'  || exit_code=1
echo "[2] access denied to admin content for ordinary user"
curl -s -u joe:joesStrongPassword http://localhost:$AREX_RUN_PORT/admin/ | grep '401.*uthoriz'  || exit_code=2
echo "[3] access allowed to admin content for admin user"
curl -s -u ann:annsStrongPassword http://localhost:$AREX_RUN_PORT/admin/ | grep 'admin content' || exit_code=3

exit $exit_code
