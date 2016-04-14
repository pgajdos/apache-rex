exit_code=0

echo 'content not relevant to the example' > $AREX_DOCUMENT_ROOT/spelling.html

echo "[1] fix case"
curl -s http://localhost:$AREX_RUN_PORT/SPELLING.HTML  | grep 301 || exit_code=1

echo "[2] fix missing character"
curl -s http://localhost:$AREX_RUN_PORT/speling.html   | grep 301 || exit_code=2

echo "[3] fix superfluous character"
curl -s http://localhost:$AREX_RUN_PORT/spellling.html | grep 301 || exit_code=3

echo "[4] fix transposition, adjacent letters"
curl -s http://localhost:$AREX_RUN_PORT/spelling.htlm  | grep 301 || exit_code=4

echo "[5] fix transposition, non adjacent letters"
# do not know why following returns 300, there just one doc there
curl -s http://localhost:$AREX_RUN_PORT/spelling.ltmh  | grep 300 || exit_code=5

echo "[6] combination case + onecharacter fix"
curl -s http://localhost:$AREX_RUN_PORT/Pselling.html  | grep 301 || exit_code=6

echo "[7] trickier combination unfixable"
curl -s http://localhost:$AREX_RUN_PORT/speling.lmth   | grep 404 || exit_code=7

exit $exit_code

