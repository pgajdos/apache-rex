exit_code=0

echo "[1] demonstrate Alias"
mkdir -p $AREX_DOCUMENT_ROOT/dir/application1/start
echo 'First Application' > $AREX_DOCUMENT_ROOT/dir/application1/start/index.html
curl -s http://localhost:$AREX_RUN_PORT/app/ | grep 'First Application' || exit_code=1

echo "[2] demonstrate AliasMatch"
mkdir -p $AREX_DOCUMENT_ROOT/dir/application2/start
echo 'Second Application' > $AREX_DOCUMENT_ROOT/dir/application2/start/index.html
curl -s http://localhost:$AREX_RUN_PORT/app1/ | grep 'First Application' || exit_code=2
curl -s http://localhost:$AREX_RUN_PORT/app2/ | grep 'Second Application' || exit_code=2

echo "[3] demonstrate Redirect"
curl -s http://localhost:$AREX_RUN_PORT/application/ | grep '302 Found' || exit_code=3
curl -s -L http://localhost:$AREX_RUN_PORT/application/ | grep 'First Application' || exit_code=3

echo "[4] demonstrate RedirectMatch"
curl -s -L http://localhost:$AREX_RUN_PORT/application1/ | grep 'First Application' || exit_code=4
curl -s -L http://localhost:$AREX_RUN_PORT/application2/ | grep 'Second Application' || exit_code=4

exit $exit_code
