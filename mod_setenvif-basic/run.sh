exit_code=0

echo "[1] demonstrate SetEnvIf directive"
mkdir -p $AREX_DOCUMENT_ROOT/customer1.example.com/
echo 'common doc' > $AREX_DOCUMENT_ROOT/doc.html
echo 'doc for customer1' > $AREX_DOCUMENT_ROOT/customer1.example.com/doc.html
curl -s http://localhost:$AREX_RUN_PORT/doc.html | grep 'common doc' || exit_code=1
curl -s --referer 'customer1.example.com' http://localhost:$AREX_RUN_PORT/doc.html | grep 'doc for customer1' || exit_code=1

exit $exit_code
