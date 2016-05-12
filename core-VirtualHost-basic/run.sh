exit_code=0

echo "[1] get correct index.html"
echo 'Main Server Index' > $AREX_DOCUMENT_ROOT/index.html
mkdir -p $AREX_DOCUMENT_ROOT-virtualhost/
echo 'Virtual Host Server Index' > $AREX_DOCUMENT_ROOT-virtualhost/index.html
curl -s http://localhost:$AREX_PORT/  | grep 'Main Server Index' || exit_code=1
curl -s http://localhost:$AREX_PORT1/ | grep 'Virtual Host Server Index' || exit_code=1

exit $exit_code

