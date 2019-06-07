exit_code=0
echo 'It works!' > $AREX_DOCUMENT_ROOT/index.html

echo "[1] allowed access trough curl command"
curl -s http://localhost:$AREX_PORT/ | grep 'It works!'

echo "[2] access forbiddend for wget command"
wget http://localhost:$AREX_PORT/ 2>&1 | grep '403: Forbidden' 

exit $exit_code

