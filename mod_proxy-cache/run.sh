exit_code=0

mkdir -p $AREX_RUN_DIR/htdocs-backend
echo 'Backend for reverse' > $AREX_RUN_DIR/htdocs-backend/index.html

echo "[1] reverse proxy with cache"
for i in $(seq 1 10); do
  curl -s -v http://localhost:$AREX_PORT2/app/ 2>&1 | grep 'X-Cache'
  sleep 0.1
done
nuncached=$(wc -l $AREX_RUN_DIR/reverse-proxy-uncached.log | sed 's: .*::')
ncached=$(wc -l $AREX_RUN_DIR/reverse-proxy-cached.log | sed 's: .*::')
nrevalidated=$(wc -l $AREX_RUN_DIR/reverse-proxy-revalidated.log | sed 's: .*::')
echo "$nuncached misses, $nrevalidated revalidates and $ncached hits"
[ $nuncached    -eq 1 ] || exit_code=1
[ $ncached      -ge 8 ] || exit_code=1
[ $nrevalidated -le 1 ] || exit_code=1


echo "[2] forward proxy with cache"
for i in $(seq 1 10); do
  curl -s -v --proxy http://localhost:$AREX_PORT3/ http://localhost:$AREX_PORT1/ 2>&1 #| grep 'X-Cache'
  sleep 0.1
done
nuncached=$(wc -l $AREX_RUN_DIR/forward-proxy-uncached.log | sed 's: .*::')
ncached=$(wc -l $AREX_RUN_DIR/forward-proxy-cached.log | sed 's: .*::')
nrevalidated=$(wc -l $AREX_RUN_DIR/forward-proxy-revalidated.log | sed 's: .*::')
echo "$nuncached misses, $nrevalidated revalidates and $ncached hits"
[ $nuncached    -eq 1 ] || exit_code=2
[ $ncached      -ge 8 ] || exit_code=2
[ $nrevalidated -le 1 ] || exit_code=2

exit $exit_code

