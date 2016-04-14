exit_code=0

# pre-test.sh creates cached.html, mmaped.html and not-cached.html
# with 'content\n' content

echo "[1] only not cached changed content does serve correctly before server restart"

echo 'changed content' > $AREX_DOCUMENT_ROOT/cached.html
echo 'changed content' > $AREX_DOCUMENT_ROOT/mmaped.html
echo 'changed content' > $AREX_DOCUMENT_ROOT/not-cached.html

# first two serve 'changed ', the third serves 'changed content'
{ curl -s http://localhost:$AREX_RUN_PORT/cached.html; 
  curl -s http://localhost:$AREX_RUN_PORT/mmaped.html;
  curl -s http://localhost:$AREX_RUN_PORT/not-cached.html; } \
 | grep 'changed changed changed content' || exit_code=1

exit $exit_code
