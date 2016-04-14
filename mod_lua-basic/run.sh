exit_code=0

# https://httpd.apache.org/docs/trunk/mod/mod_lua.html#writinghandlers
echo "[1] lua request handler example"
cp example_handler.lua $AREX_DOCUMENT_ROOT
curl -s -X GET  "http://localhost:$AREX_RUN_PORT/example_handler.lua?user=kremilek&action=povidla" \
  | grep 'user: kremilek' || exit_code=1
curl -s -X POST --data "user=vochomurka&action=povidla" http://localhost:$AREX_RUN_PORT/example_handler.lua \
  | grep 'action: povidla' || exit_code=1
curl -s -X PUT  http://localhost:$AREX_RUN_PORT/example_handler.lua \
  | grep 'Unsupported HTTP method PUT' || exit_code=1

exit $exit_code
