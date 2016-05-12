exit_code=0

echo "[1] show DirectoryIndex directive basic functionality"
mkdir -p $AREX_DOCUMENT_ROOT/dir{1,2,3}
echo 'text index'  > $AREX_DOCUMENT_ROOT/dir1/index.txt
echo 'php index'   > $AREX_DOCUMENT_ROOT/dir2/index.php
echo 'html index'  > $AREX_DOCUMENT_ROOT/dir3/index.html
curl -s http://localhost:$AREX_PORT/dir1/ | grep 'text index'    || exit_code=1
curl -s http://localhost:$AREX_PORT/dir2/ | grep 'php index'     || exit_code=1
curl -s http://localhost:$AREX_PORT/dir3/ | grep '404 Not Found' || exit_code=1

exit $exit_code

