exit_code=0

cp hooks.lua $AREX_RUN_DIR
echo 'site index' > $AREX_DOCUMENT_ROOT/index.html 

curl -s http://localhost:$AREX_RUN_PORT/notexisting.html >/dev/null
curl -s http://localhost:$AREX_RUN_PORT/ >/dev/null

echo "hook_log ---"
cat $AREX_DOCUMENT_ROOT/hook_log
echo "------------"
echo

grep '/notexisting.html: hello from quick handler' $AREX_DOCUMENT_ROOT/hook_log || exit_code=1
grep '/: hello from map to storage hook'           $AREX_DOCUMENT_ROOT/hook_log || exit_code=1
grep '/index.html: hello from log hook'            $AREX_DOCUMENT_ROOT/hook_log || exit_code=1

exit $exit_code
