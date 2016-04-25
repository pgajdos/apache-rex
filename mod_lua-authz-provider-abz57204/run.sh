exit_code=0

cp lua_authz.lua $AREX_RUN_DIR
mkdir -p $AREX_DOCUMENT_ROOT/dir

echo "[1] lua authz function is called with correct parameter"
curl -s http://localhost:$AREX_RUN_PORT1/notexisting.html > /dev/null
curl -s http://localhost:$AREX_RUN_PORT1/dir/notexisting.html > /dev/null
curl -s http://localhost:$AREX_RUN_PORT2/notexisting.html > /dev/null
curl -s http://localhost:$AREX_RUN_PORT2/dir/notexisting.html > /dev/null
# write the error_log into log
cat $AREX_RUN_DIR/error_log | grep '\[lua:warn\]'
# 
lua_authz_args=$(cat $AREX_RUN_DIR/error_log | grep '\[lua:warn\]' | sed -e 's:.*lua_authz ::' | tr -d '\n ')
[ "$lua_authz_args" == "1243" ] || exit_code=1

exit $exit_code
