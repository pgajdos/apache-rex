exit_code=0

echo 'main index' > $AREX_DOCUMENT_ROOT/index.html
echo 'document'   > $AREX_DOCUMENT_ROOT/document.html

echo "[1] user is tracked in log trough cookie"
cookie=$(curl -s -i http://localhost:$AREX_PORT/ | grep 'Set-Cookie:' | sed 's/Set-Cookie: //' | tr -d '\r')
# just informative output of the cookie
echo "Cookie: $cookie"
curl -s  -H "Cookie: $cookie" http://localhost:$AREX_PORT/ > /dev/null
curl -s  -H "Cookie: $cookie" http://localhost:$AREX_PORT/document.html > /dev/null

id=$(echo "$cookie" | sed "s:trackcookie=\(.*\);.*:\1:")
grep "$id" $AREX_RUN_DIR/usertrack_log || exit_code=1

exit $exit_code

