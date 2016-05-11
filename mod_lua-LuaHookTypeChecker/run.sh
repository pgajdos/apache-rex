exit_code=0

cp hooks.lua $AREX_RUN_DIR

echo 'English Documentation' > $AREX_DOCUMENT_ROOT/document.en.html
echo 'documentation française' > $AREX_DOCUMENT_ROOT/document.fr.html

curl -s -v                          http://localhost:$AREX_RUN_PORT/document.html > $AREX_RUN_DIR/out.1 2>&1
curl -s -v -H 'Accept-Language: en' http://localhost:$AREX_RUN_PORT/document.html > $AREX_RUN_DIR/out.2 2>&1
curl -s -v -H 'Accept-Language: fr' http://localhost:$AREX_RUN_PORT/document.html > $AREX_RUN_DIR/out.3 2>&1

echo "[1] correct header Language: in response"
grep 'English Documentation'   $AREX_RUN_DIR/out.1
# Language: is not set when Accept-Language: is not received
grep '< Language: en'          $AREX_RUN_DIR/out.1 && exit_code=1
grep 'English Documentation'   $AREX_RUN_DIR/out.2
grep '< Language: en'          $AREX_RUN_DIR/out.2 || exit_code=1
grep 'documentation française' $AREX_RUN_DIR/out.3
grep '< Language: fr'          $AREX_RUN_DIR/out.3 || exit_code=1

exit $exit_code
