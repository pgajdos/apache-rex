exit_code=0

echo "[1] document test.tst is recognized as bar/tst"
echo 'helloworld' > $AREX_DOCUMENT_ROOT/test.tst
curl -s http://localhost:$AREX_PORT/test.tst  | grep  'HELLOWORLD' || exit_code=1

# precence in mime.types
# inspired by resolution of http://marc.info/?l=apache-httpd-users&m=147444867019367
echo "[2] former occurence of the same extension is shadowed by latter one"
echo 'hiho'  > $AREX_DOCUMENT_ROOT/test.xml
curl -s http://localhost:$AREX_PORT/test.xml  | grep 'hiho' || exit_code=2
echo 'blebleble' > $AREX_DOCUMENT_ROOT/test.xml2
curl -s http://localhost:$AREX_PORT/test.xml2 | grep 'BLEBLEBLE' || exit_code=2

# precedence off AddType before mime.types
echo "[3] AddType shadows assignment in mime.types for the same extension"
echo 'tchuss' > $AREX_DOCUMENT_ROOT/test.txt
curl -s http://localhost:$AREX_PORT/test.txt | grep 'tchuss' || exit_code=3 

exit $exit_code
