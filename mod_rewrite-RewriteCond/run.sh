exit_code=0

# see https://httpd.apache.org/docs/trunk/rewrite/intro.html

echo "[1] %{HTTP_HOST} is correctly translated to different path"
mkdir -p $AREX_DOCUMENT_ROOT/sites/127.0.0.1/foo/bar/
echo '127.0.0.1 site' > $AREX_DOCUMENT_ROOT/sites/127.0.0.1/foo/bar/index.html
mkdir -p $AREX_DOCUMENT_ROOT/sites/127.0.0.2/foo/bar/
echo '127.0.0.2 site' > $AREX_DOCUMENT_ROOT/sites/127.0.0.2/foo/bar/index.html
curl -s http://127.0.0.1:$AREX_PORT/foo/bar/ | grep '127.0.0.1 site' || exit_code=1
curl -s http://127.0.0.2:$AREX_PORT/foo/bar/ | grep '127.0.0.2 site' || exit_code=1

echo "[2] %{QUERY_STRING} is correctly translated to different path"
echo 'PAGE 3' > $AREX_DOCUMENT_ROOT/sites/127.0.0.1/foo/bar/page3.html
echo 'PAGE 2' > $AREX_DOCUMENT_ROOT/sites/127.0.0.2/foo/bar/page2.html
curl -s http://127.0.0.1:$AREX_PORT/foo/bar/index.html?page=3 | grep 'PAGE 3' || exit_code=2
curl -s http://127.0.0.2:$AREX_PORT/foo/bar/index.html?page=2 | grep 'PAGE 2' || exit_code=2

exit $exit_code

