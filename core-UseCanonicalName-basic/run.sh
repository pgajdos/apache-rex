exit_code=0

echo "[1] server uses ServerName in generated content"
mkdir -p $AREX_DOCUMENT_ROOT/dir
echo 'content not reached' > $AREX_DOCUMENT_ROOT/dir/index.html
curl -s -i http://localhost:$AREX_RUN_PORT/dir | grep 'Location: http://www.domain.com/dir/' || exit_code=1

exit $exit_code

