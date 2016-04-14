exit_code=0

for id in backend1 backend2 fallback; do
  mkdir -p $AREX_RUN_DIR/htdocs-vh-$id
  echo "server $id" > $AREX_RUN_DIR/htdocs-vh-$id/index.html
done

echo "[1] VirtualHosts are properly defined"
for i in $(seq 1 20); do 
  curl -s http://localhost:60084/
done | tee $AREX_RUN_DIR/run.out
grep 'server backend2' $AREX_RUN_DIR/run.out || exit_code=1
grep 'server backend1' $AREX_RUN_DIR/run.out || exit_code=1
ls  $AREX_RUN_DIR/error_log-fallback || exit_code=1

exit $exit_code

