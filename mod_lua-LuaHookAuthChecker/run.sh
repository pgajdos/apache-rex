exit_code=0

cp hooks.lua $AREX_RUN_DIR

htpasswd -bc $AREX_RUN_DIR/htpasswd puskvorec PuskvorecsPassword
htpasswd -b  $AREX_RUN_DIR/htpasswd brcalnik  BrcalniksPassword

echo 'site index' > $AREX_DOCUMENT_ROOT/index.html
echo 'a document' > $AREX_DOCUMENT_ROOT/document.html


echo "[1] use auth_checker for tracking user activity for each dir accessed"
curl -s -u 'puskvorec:PuskvorecsPassword' http://localhost:$AREX_PORT/index.html
curl -s -u 'puskvorec:PuskvorecsPassword' http://localhost:$AREX_PORT/document.html
curl -s -u 'brcalnik:BrcalniksPassword'   http://localhost:$AREX_PORT/document.html

echo -n 'brcalnik:  '
grep '^|$'  $AREX_DOCUMENT_ROOT/brcalnik.activity  || exit_code=1
echo -n 'puskvorec: '
grep '^||$' $AREX_DOCUMENT_ROOT/puskvorec.activity || exit_code=1

exit $exit_code
