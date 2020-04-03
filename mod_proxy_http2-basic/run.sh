exit_code=0

mkdir -p $AREX_DOCUMENT_ROOT/vh1
echo "h2 proxy hello"  > $AREX_DOCUMENT_ROOT/vh1/index.html
mkdir -p $AREX_DOCUMENT_ROOT/vh2
echo "h2c proxy hello" > $AREX_DOCUMENT_ROOT/vh2/index.html

echo "[1] h2 trough proxy"
curl -s http://localhost:$AREX_PORT3/app-h2  | grep 'h2 proxy hello'  || exit_code=1
echo "[2] h2c trough proxy"
curl -s http://localhost:$AREX_PORT4/app-h2c | grep 'h2c proxy hello' || exit_code=2

exit $exit_code

