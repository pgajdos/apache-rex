exit_code=0

echo 'site index' > $AREX_DOCUMENT_ROOT/index.html

echo "[1] "
curl -s -k https://localhost:$AREX_PORT1/ | grep 'site index' || exit_code=1
curl -s    http://localhost:$AREX_PORT2/  | grep 'site index' || exit_code=1

exit $exit_code 
