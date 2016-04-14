exit_code=0

mkdir -p $AREX_DOCUMENT_ROOT/{foo,bar}
for i in "/" "/foo" "/bar"; do
  echo "$i directory index" > $AREX_DOCUMENT_ROOT$i/index.html
done

echo "[1] both new and old access systems allow access"
curl -s http://localhost:$AREX_RUN_PORT/   | grep '/ directory index' || exit_code=1
echo "[2] old system forbids access" 
curl -s http://localhost:$AREX_RUN_PORT/foo | grep '403 Forbidden'    || exit_code=2
echo "[3] new system forbids access"
curl -s http://localhost:$AREX_RUN_PORT/bar | grep '403 Forbidden'    || exit_code=3

exit $exit_code

