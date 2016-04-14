exit_code=0

echo "[1] demonstrate FallbackResource directive basic functionality"
mkdir -p $AREX_DOCUMENT_ROOT/dir
echo 'welcome to the gallery'   > $AREX_DOCUMENT_ROOT/dir/welcome.txt
echo 'gallery thumnail'         > $AREX_DOCUMENT_ROOT/dir/thumbnail.php
# welcome.txt exists -> no 404 -> no fallback is chosen
curl -s http://localhost:$AREX_RUN_PORT/dir/ | grep 'welcome to the gallery' || exit_code=1
# would got 404, fallback is chosen
curl -s http://localhost:$AREX_RUN_PORT/dir/not-existing.html | grep 'gallery thumnail' || exit_code=1

exit $exit_code

