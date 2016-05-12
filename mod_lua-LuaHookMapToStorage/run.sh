exit_code=0

echo "[1] implement dummy disk cache (slow disk -> quick disk)"
mkdir -p $AREX_RUN_DIR/quick-disk

cp hooks.lua $AREX_RUN_DIR

echo 'main index' > $AREX_DOCUMENT_ROOT/index.html
mkdir -p            $AREX_DOCUMENT_ROOT/{icons,images}
cp apache_pb.png    $AREX_DOCUMENT_ROOT/images
cp apache_pb.gif    $AREX_DOCUMENT_ROOT/images
cp image.png        $AREX_DOCUMENT_ROOT/icons

# html file is served as usual, without caching
curl -s http://localhost:$AREX_PORT/ | grep 'main index' || exit_code=1
# MISS
curl -s http://localhost:$AREX_PORT/images/apache_pb.png > $AREX_RUN_DIR/downloaded.png
file $AREX_RUN_DIR/downloaded.png | grep  'PNG image data' || exit_code=1
# MISS
curl -s http://localhost:$AREX_PORT/images/apache_pb.gif > $AREX_RUN_DIR/downloaded.gif
# HIT
curl -s http://localhost:$AREX_PORT/images/apache_pb.png > $AREX_RUN_DIR/downloaded.png
# HIT
curl -s http://localhost:$AREX_PORT/images/apache_pb.png > $AREX_RUN_DIR/downloaded.png
# MISS
curl -s http://localhost:$AREX_PORT/icons/image.png > $AREX_RUN_DIR/downloaded.png
# HIT
curl -s http://localhost:$AREX_PORT/icons/image.png > $AREX_RUN_DIR/downloaded.png

cache_result=$(cat $AREX_RUN_DIR/error_log | grep '\(HIT\|MISS\)' | sed 's:.*\(HIT\|MISS\).*:\1:' | tr '\n' ' ')
echo "$cache_result" || grep "MISS MISS HIT HIT MISS HIT" || exit_code=1

exit $exit_code
