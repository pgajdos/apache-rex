exit_code=0

echo "[1] send document as-is (correct: with headers)"
cat << EOF > $AREX_DOCUMENT_ROOT/correct.asis
Content-type: text/plain

DOCUMENT DATA
EOF
curl -s http://localhost:$AREX_RUN_PORT/correct.asis > $AREX_RUN_DIR/out-as-is.txt
grep 'DOCUMENT DATA' $AREX_RUN_DIR/out-as-is.txt || exit_code=1
grep 'Content-type: text/plain' $AREX_RUN_DIR/out-as-is.txt && exit_code=1

echo "[2] send document as-is (incorrect: without headers)"
cat << EOF > $AREX_DOCUMENT_ROOT/wrong.asis
DOCUMENT DATA
EOF
curl -s http://localhost:$AREX_RUN_PORT/wrong.asis
grep 'malformed header' $AREX_RUN_DIR/error_log || exit_code=2

echo "[3] document with another extension will not be send as-is"
cat << EOF > $AREX_DOCUMENT_ROOT/document.html
Content-type: text/plain

DOCUMENT DATA
EOF
curl -s http://localhost:$AREX_RUN_PORT/document.html > $AREX_RUN_DIR/out-not-as-is.txt
grep 'Content-type: text/plain' $AREX_RUN_DIR/out-not-as-is.txt || exit_code=3
grep 'DOCUMENT DATA' $AREX_RUN_DIR/out-not-as-is.txt || exit_code=3

exit $exit_code

