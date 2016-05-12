exit_code=0

echo "[1] custom output filter rewrites html document content"
echo 'It does not work!' > $AREX_DOCUMENT_ROOT/index.html
curl -s http://localhost:$AREX_PORT/ | grep 'It works!' || exit_code=1

exit $exit_code

