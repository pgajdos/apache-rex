exit_code=0

echo "[1] demonstrate Header directive"
echo 'server index' > $AREX_DOCUMENT_ROOT/index.html
curl -s -i \
  --referer hans.ex.com \
  -H 'my-header-ip: 1.2.3.4' \
  -H 'my-header-port: 50' \
  -H 'my-header-user: joe' \
  http://localhost:$AREX_PORT1/ > $AREX_RUN_DIR/header-out.txt
grep 'my-header-ip: 1.2.3.4'            $AREX_RUN_DIR/header-out.txt || exit_code=1
grep 'my-header-port: 50'               $AREX_RUN_DIR/header-out.txt || exit_code=1
grep 'my-header-rqinfo:.*UTC.*duration' $AREX_RUN_DIR/header-out.txt || exit_code=1
grep 'my-header-referer: hans.ex.com'   $AREX_RUN_DIR/header-out.txt || exit_code=1
grep 'my-header-user'                   $AREX_RUN_DIR/header-out.txt && exit_code=1

# the same, but custom headers given trough proxy
echo "[2] demonstrate RequestHeader directive"
curl -s --referer hans.ex.com -i http://localhost:$AREX_PORT2/ > $AREX_RUN_DIR/header-proxy-out.txt
grep 'my-header-ip: 1.2.3.4'            $AREX_RUN_DIR/header-proxy-out.txt || exit_code=2
grep 'my-header-port: 50'               $AREX_RUN_DIR/header-proxy-out.txt || exit_code=2
grep 'my-header-rqinfo:.*UTC.*duration' $AREX_RUN_DIR/header-proxy-out.txt || exit_code=2
grep 'my-header-referer: hans.ex.com'   $AREX_RUN_DIR/header-proxy-out.txt || exit_code=2
grep 'my-header-user'                   $AREX_RUN_DIR/header-proxy-out.txt && exit_code=2

exit $exit_code
