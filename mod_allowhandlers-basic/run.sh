exit_code=0

mkdir -p $AREX_DOCUMENT_ROOT/{scripts,data,server-status/archive}
cp hello.lua $AREX_DOCUMENT_ROOT/scripts
cp hello.lua $AREX_DOCUMENT_ROOT/data
echo 'data info' > $AREX_DOCUMENT_ROOT/data/README.txt
echo 'internal script info' > $AREX_DOCUMENT_ROOT/scripts/README.txt

echo "[1] script is run from /scripts directory"
curl -s http://localhost:$AREX_PORT/scripts/hello.lua      | grep 'hello lua world!'      || exit_code=1
echo "[2] data can not be downloaded from /scripts directory"
curl -s http://localhost:$AREX_PORT/scripts/README.txt     | grep 'don.t have permission' || exit_code=2
echo "[3] script is forbidden to run from /data directory"
curl -s http://localhost:$AREX_PORT/data/hello.lua         | grep 'don.t have permission' || exit_code=3
echo "[4] data can be downloaded from /scripts directory"
curl -s http://localhost:$AREX_PORT/data/README.txt        | grep 'data info'             || exit_code=4
echo "[5] location is not allowed via forbidden handler"
curl -s http://localhost:$AREX_PORT/not-available/         | grep 'don.t have permission' || exit_code=5
echo "[6] server-status handler is run for /server-status"
curl -s http://localhost:$AREX_PORT/server-status/         | grep 'Apache Status'         || exit_code=6
echo "[7] server-status handler is not run for /server-status/archive"
curl -s http://localhost:$AREX_PORT/server-status/archive/ | grep 'don.t have permission' || exit_code=7

exit $exit_code
