exit_code=0
echo 'It works!' > $AREX_DOCUMENT_ROOT/index.html

echo "[1] allowed access trough curl command"
curl -v -s http://localhost:$AREX_PORT/ 2>&1 | grep 'User-Agent\|It works!' || exit_code=1

echo "[2] access forbiddend for wget command"
wget http://localhost:$AREX_PORT/ 2>&1 | grep '403: Forbidden' || exit_code=2

exit $exit_code

