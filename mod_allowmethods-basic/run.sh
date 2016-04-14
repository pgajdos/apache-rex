exit_code=0

mkdir -p $AREX_DOCUMENT_ROOT/{get,post}
echo 'retrieved by GET'  > $AREX_DOCUMENT_ROOT/get/index.html
echo 'retrieved by POST' > $AREX_DOCUMENT_ROOT/post/index.html

echo "[1] GET allowed"
curl -s http://localhost:$AREX_RUN_PORT/get/ | grep 'retrieved by GET' || exit_code=1
echo "[2] POST disallowed"
curl -s -X POST http://localhost:$AREX_RUN_PORT/get/ | grep '405 Method Not Allowed' || exit_code=2
echo "[3] POST allowed"
curl -s -X POST http://localhost:$AREX_RUN_PORT/post/ | grep 'retrieved by POST' || exit_code=3
echo "[4] GET disallowed"
curl -s http://localhost:$AREX_RUN_PORT/post/ | grep '405 Method Not Allowed' || exit_code=4

exit $exit_code
