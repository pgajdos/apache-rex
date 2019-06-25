exit_code=0

mkdir -p      $AREX_DOCUMENT_ROOT/fcgi-bin
cp showenv.pl $AREX_DOCUMENT_ROOT/fcgi-bin/
chmod 755     $AREX_DOCUMENT_ROOT/fcgi-bin/showenv.pl
mkdir -p      $AREX_RUN_DIR/ipc/shm

echo
echo "[1] request is proxied to fcgi application"
curl -s http://localhost:$AREX_PORT/fcgi-bin/showenv.pl?a=true | grep 'QUERY_STRING = a=true' || exit_code=1

echo "[2] error log contains output to STDERR"
grep 'request received' $AREX_RUN_DIR/error_log || exit_code=2

exit $exit_code

