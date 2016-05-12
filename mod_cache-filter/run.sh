exit_code=0

mkdir -p $AREX_RUN_DIR/cacheroot
mkdir -p $AREX_DOCUMENT_ROOT/cached-{after,before}-ssi
cat << EOF > $AREX_DOCUMENT_ROOT/cached-after-ssi/date.shtml
<!--#echo var="DATE_LOCAL" -->
EOF
cat << EOF > $AREX_DOCUMENT_ROOT/cached-before-ssi/date.shtml
<!--#echo var="DATE_LOCAL" -->
EOF

echo "[1] cached after ssi, so almost no hit"
for i in $(seq 1 30); do
  curl -s -v http://localhost:$AREX_PORT/cached-after-ssi/date.shtml  2>&1 | grep 'X-Cache:'
  sleep 1
done | tee $AREX_RUN_DIR/cached-after-ssi.log
nhits=$(grep -c "HIT" $AREX_RUN_DIR/cached-after-ssi.log)
nmisses=$(grep -c "MISS" $AREX_RUN_DIR/cached-after-ssi.log)
echo "$nmisses misses, $nhits hits"
[ $nhits -eq 0 -a $nmisses -eq 30 ] || exit_code=1


echo "[2] cached before ssi, so there should be hits"
for i in $(seq 1 30); do
  curl -s -v http://localhost:$AREX_PORT/cached-before-ssi/date.shtml 2>&1 | grep 'X-Cache:'
  sleep 1
done | tee $AREX_RUN_DIR/cached-before-ssi.log
nhits=$(grep -c "HIT" $AREX_RUN_DIR/cached-before-ssi.log)
nmisses=$(grep -c "MISS" $AREX_RUN_DIR/cached-before-ssi.log)
echo "$nmisses misses, $nhits hits"
[ $nhits -ge $nmisses ] || exit_code=2

exit $exit_code
