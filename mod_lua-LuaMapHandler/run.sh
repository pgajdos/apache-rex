exit_code=0

cp pangram.lua $AREX_RUN_DIR

mkdir $AREX_DOCUMENT_ROOT/pangrams/
echo 'Jived fox nymph grabs quick waltz.' > $AREX_DOCUMENT_ROOT/pangrams/en.txt

echo [1] get data converted by lua functions
curl -s http://localhost:$AREX_PORT/pangram?id=en          | grep 'Jived fox nymph grabs quick waltz.' || exit_code=1
curl -s http://localhost:$AREX_PORT/pangram/to_lower?id=en | grep 'jived fox nymph grabs quick waltz.' || exit_code=1
curl -s http://localhost:$AREX_PORT/pangram/to_upper?id=en | grep 'JIVED FOX NYMPH GRABS QUICK WALTZ.' || exit_code=1
curl -s http://localhost:$AREX_PORT/pangram?id=de          | grep 'pangram not found this language'    || exit_code=1

exit $exit_code
