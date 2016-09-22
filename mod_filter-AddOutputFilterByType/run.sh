exit_code=0

echo "[1] document test.xml (content: helloworld) is recognized as test/xml"
mkdir -p $AREX_DOCUMENT_ROOT/text-xml
echo 'helloworld' > $AREX_DOCUMENT_ROOT/text-xml/test.xml
curl -s http://localhost:$AREX_PORT/text-xml/test.xml | grep 'HELLOWORLD' || exit_code=1

echo "[2] document test.xml (content: helloworld) is NOT recognized as application/xml"
mkdir -p $AREX_DOCUMENT_ROOT/application-xml
echo 'helloworld' > $AREX_DOCUMENT_ROOT/application-xml/test.xml
curl -s http://localhost:$AREX_PORT/application-xml/test.xml | grep  'helloworld' || exit_code=1

echo "[3] document test.xml (content: helloworld) is recognized as application/xml when AddType used"
mkdir -p $AREX_DOCUMENT_ROOT/application-xml-defined
echo 'helloworld' > $AREX_DOCUMENT_ROOT/application-xml-defined/test.xml
curl -s http://localhost:$AREX_PORT/application-xml-defined/test.xml # | grep  'helloworld' || exit_code=1

exit $exit_code
