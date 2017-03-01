exit_code=0

echo "[1] write to the session in a cgi script"
cp session-status.sh $AREX_DOCUMENT_ROOT
chmod 755    $AREX_DOCUMENT_ROOT/session-status.sh
cookie=$(curl -s -i "http://localhost:$AREX_PORT/session-status.sh?var1=foo&var2=bar" \
           | grep 'Set-Cookie:' | head -n 1 | sed 's:Set-::' | tr -d '\r')
echo $cookie | grep 'session=var1=foo&var2=bar' || exit_code=1

echo "[2] read from the session in a cgi script"
curl -s -H "$cookie" http://localhost:$AREX_PORT/session-status.sh | grep 'var1=foo&var2=bar' || exit_code=2


exit $exit_code

