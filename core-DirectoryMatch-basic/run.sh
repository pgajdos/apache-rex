exit_code=0

mkdir -p $AREX_DOCUMENT_ROOT/{001,subdir/002,subdir/subsubdir/003,0004}
echo 'hello from 001'  > $AREX_DOCUMENT_ROOT/001/index.html
echo 'hello from 002'  > $AREX_DOCUMENT_ROOT/subdir/002/index.html
echo 'hello from 003'  > $AREX_DOCUMENT_ROOT/subdir/subsubdir/003/index.html
echo 'hello from 0004' > $AREX_DOCUMENT_ROOT/0004/index.html

echo "[1] allow access just into subdirectories specified by DirectoryMatch"
curl -s http://localhost:$AREX_PORT/ | grep '403 Forbidden' || exit_code=1
curl -s http://localhost:$AREX_PORT/001/ | grep 'hello from 001' || exit_code=1
curl -s http://localhost:$AREX_PORT/subdir/002/ | grep 'hello from 002' || exit_code=1
curl -s http://localhost:$AREX_PORT/subdir/subsubdir/003/ | grep 'hello from 003' || exit_code=1
curl -s http://localhost:$AREX_PORT/0004/ | grep '403 Forbidden' || exit_code=1

exit $exit_code
