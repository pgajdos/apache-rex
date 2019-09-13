exit_code=0

echo "[1] basic log message"
mkdir -p $AREX_DOCUMENT_ROOT/a/
echo "index" > $AREX_DOCUMENT_ROOT/a/index.html
curl -s http://localhost:$AREX_PORT/a/index.html          > /dev/null
curl -s http://localhost:$AREX_PORT/a/b/not-existing.html > /dev/null
grep 'request under /a/ .*index.html'        $AREX_RUN_DIR/error_log || exit_code=1
grep 'request under /a/ .*not-existing.html' $AREX_RUN_DIR/error_log || exit_code=1

echo
echo "[2] log of request and internal request after rewrite"
mkdir -p $AREX_DOCUMENT_ROOT/foo/
echo 'Welcome!' > $AREX_DOCUMENT_ROOT/foo/welcome.html
curl -s http://localhost:$AREX_PORT/foo/bar.html > /dev/null 
grep 'has been requested' $AREX_RUN_DIR/error_log || exit_code=2
echo

echo "[3] expose a header in error_log, Range: in this case"
mkdir -p $AREX_DOCUMENT_ROOT/weather/
echo 'Today, there will be raining whole day.'  > $AREX_DOCUMENT_ROOT/weather/data.txt
curl -s    -o $AREX_RUN_DIR/weather-data.txt http://localhost:$AREX_PORT/weather/data.txt
echo 'Today, there will be snowing whole day.' >> $AREX_DOCUMENT_ROOT/weather/data.txt
curl -s -C -  -o $AREX_RUN_DIR/weather-data.txt http://localhost:$AREX_PORT/weather/data.txt
echo 'Otherwise the weather will be different.'>> $AREX_DOCUMENT_ROOT/weather/data.txt
curl -s -C -  -o $AREX_RUN_DIR/weather-data.txt http://localhost:$AREX_PORT/weather/data.txt
grep 'weather info: hi'        $AREX_RUN_DIR/error_log || exit_code=3
grep 'weather info: bytes=40-' $AREX_RUN_DIR/error_log || exit_code=3
grep 'weather info: bytes=80-' $AREX_RUN_DIR/error_log || exit_code=3

exit $exit_code

