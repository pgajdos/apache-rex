exit_code=0

echo "[1] chaining unrelated filters"
echo 'this is a sample text' > $AREX_DOCUMENT_ROOT/document.html
curl -s http://localhost:$AREX_RUN_PORT/document.html | grep 'this is a SAMPLE TEXT' || exit_code=1

echo "[2] output depends on previous filter result"
echo 'this is a sample text' > $AREX_DOCUMENT_ROOT/document.doc
curl -s http://localhost:$AREX_RUN_PORT/document.doc | grep 'this is a SaMpLe text' || exit_code=2

echo "[3] inverse filter ordering can produce another result"
echo 'this is a sample text' > $AREX_DOCUMENT_ROOT/document.txt
curl -s http://localhost:$AREX_RUN_PORT/document.txt | grep 'this is a SAMPLE text' || exit_code=3

exit $exit_code

