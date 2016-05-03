exit_code=0

cp hooks.lua $AREX_RUN_DIR/

mkdir -p $AREX_DOCUMENT_ROOT/{public,private}_area/
echo public index  > $AREX_DOCUMENT_ROOT/public_area/index.html
echo private index > $AREX_DOCUMENT_ROOT/private_area/index.html

echo "[1] usertrack example with logging information limited to certain locations"
cookie=$(curl -s -i http://localhost:$AREX_RUN_PORT/ | grep 'Set-Cookie:' | sed 's/Set-Cookie: //' | tr -d '\r')
curl -s  -H "Cookie: $cookie" http://localhost:$AREX_RUN_PORT/public_area/ > /dev/null
curl -s  -H "Cookie: $cookie" http://localhost:$AREX_RUN_PORT/private_area/ > /dev/null

grep 'GET /public_area/'  $AREX_RUN_DIR/usertrack_log || exit_code=1
grep 'GET /private_area/' $AREX_RUN_DIR/usertrack_log && exit_code=1

exit $exit_code
