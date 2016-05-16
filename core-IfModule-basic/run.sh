exit_code=0

echo 'site index' > $AREX_DOCUMENT_ROOT/index.html
echo 'site index, generated at <!--#echo var="DATE_LOCAL" -->' > $AREX_DOCUMENT_ROOT/index.shtml

echo "[1] detect that include module is loaded"
curl -s http://localhost:$AREX_PORT/index.html | grep 'site index, generated at' || exit_code=1

exit $exit_code
