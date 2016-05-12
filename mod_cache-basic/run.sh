exit_code=0

echo "main index" > $AREX_DOCUMENT_ROOT/index.html

echo "[1] there are few misses, few hits and many revalidates in first 30s"
for i in $(seq 1 30); do
  curl -s -v http://localhost:$AREX_PORT/index.html 2>&1 | grep 'X-Cache\|Age'
  sleep 1
done
nuncached=$(wc -l $AREX_RUN_DIR/uncached-requests.log | sed 's: .*::')
ncached=$(wc -l $AREX_RUN_DIR/cached-requests.log | sed 's: .*::')
nrevalidated=$(wc -l $AREX_RUN_DIR/revalidated-requests.log | sed 's: .*::')
echo "$nuncached misses, $nrevalidated revalidates and $ncached hits"
[ $nuncached    -gt 0  ] || exit_code=1
[ $ncached      -gt 0  ] || exit_code=1
[ $nrevalidated -gt 10 ] || exit_code=1

echo "[2] miss after content change"
# age the cache
sleep 1
echo "welcome" > $AREX_DOCUMENT_ROOT/index.html
# max-age=1 to forces revalidation, but the content
# was changed -> miss
curl -s -v -H 'Cache-Control: max-age=1' http://localhost:$AREX_PORT/index.html 2>&1 | grep 'X-Cache:.*MISS' || exit_code=2

echo "[3] miss with Cache-Control: no-cache"
curl -s -v -H 'Cache-Control: no-cache' http://localhost:$AREX_PORT/index.html 2>&1 | grep 'X-Cache:.*MISS' || exit_code=3
curl -s -v -H 'Cache-Control: no-cache' http://localhost:$AREX_PORT/index.html 2>&1 | grep 'X-Cache:.*MISS' || exit_code=3
curl -s -v -H 'Cache-Control: no-cache' http://localhost:$AREX_PORT/index.html 2>&1 | grep 'X-Cache:.*MISS' || exit_code=3


exit $exit_code
