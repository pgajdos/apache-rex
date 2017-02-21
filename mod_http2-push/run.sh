exit_code=0

mkdir -p $AREX_DOCUMENT_ROOT/{images,css}
echo 'site index' > $AREX_DOCUMENT_ROOT/index.html
echo 'logo image' > $AREX_DOCUMENT_ROOT/images/logo.jpg
echo 'css style'  > $AREX_DOCUMENT_ROOT/css/site.css

echo "[1] image and css style is pushed to us"
nghttp https://localhost:$AREX_PORT/ > $AREX_RUN_DIR/index_out
grep 'site index' $AREX_RUN_DIR/index_out || exit_code=1
grep 'css style'  $AREX_RUN_DIR/index_out || exit_code=1
grep 'logo image' $AREX_RUN_DIR/index_out || exit_code=1

exit $exit_code
