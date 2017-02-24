exit_code=0

mkdir -p $AREX_RUN_DIR/htdocs-backend
mkdir -p $AREX_DOCUMENT_ROOT/mirror/foo
echo 'Backend index'     > $AREX_RUN_DIR/htdocs-backend/index.html
echo 'Backend document'  > $AREX_RUN_DIR/htdocs-backend/document.html
echo 'Backend image'     > $AREX_RUN_DIR/htdocs-backend/image.png
echo 'Frontend index'    > $AREX_DOCUMENT_ROOT/mirror/foo/index.html
echo 'Frontend document' > $AREX_DOCUMENT_ROOT/mirror/foo/document.html
echo 'Frontend Image'    > $AREX_DOCUMENT_ROOT/mirror/foo/image.png

echo "[1] ProxyPass <location> !"
curl -s http://localhost:$AREX_PORT/mirror/foo/index.html | grep 'Frontend index' || exit_code=1
curl -s http://localhost:$AREX_PORT/mirror/foo/document.html | grep 'Backend document' || exit_code=1

echo "[2] no-proxy environment variable"
result=$(curl -s http://localhost:$AREX_PORT/mirror/foo/image.png)
# no-proxy variable is taken into account from 2.5.0 and above so far
if [ $AREX_APACHE_VERSION -ge 20500 ]; then
  grep 'Frontend Image' $result || exit_code=2
else
  echo 'skipped, no-proxy is ignored until httpd version 2.5.0'
fi


exit $exit_code
