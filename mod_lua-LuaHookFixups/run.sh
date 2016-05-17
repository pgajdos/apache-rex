exit_code=0

cp hooks.lua $AREX_RUN_DIR

echo 'English Documentation'   > $AREX_DOCUMENT_ROOT/document.en.html
echo 'documentation française' > $AREX_DOCUMENT_ROOT/document.fr.html

echo "[1] 'last minute' changes in fixups phase"
curl -s -H 'Accept-Language: en' http://localhost:$AREX_PORT/document.html
curl -s -H 'Accept-Language: fr' http://localhost:$AREX_PORT/document.html
cat $AREX_RUN_DIR/error_log | grep 'translate again' || exit_code=1

exit $exit_code
