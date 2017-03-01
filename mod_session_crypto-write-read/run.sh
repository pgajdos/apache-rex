exit_code=0

# see mod_session-write-read for unencrypted example
echo "[1] write and read to the session in a cgi script"
cp session-status.sh $AREX_DOCUMENT_ROOT
chmod 755    $AREX_DOCUMENT_ROOT/session-status.sh
cookie=$(curl -s -i "http://localhost:$AREX_PORT/session-status.sh?var1=foo&var2=bar" \
           | grep 'Set-Cookie:' | head -n 1 | sed 's:Set-::' | tr -d '\r')
echo "Encrypted $cookie"
curl -s -H "$cookie" http://localhost:$AREX_PORT/session-status.sh | grep 'var1=foo&var2=bar' || exit_code=1

exit $exit_code

