exit_code=0

echo "[1] Content-MD5 header is included in the response"
echo 'a document' > $AREX_DOCUMENT_ROOT/document.html
curl -s -v http://localhost:$AREX_PORT/document.html 2>&1 | grep 'Content-MD5' || exit_code=1

exit $exit_code
