exit_code=0

echo "[1] virtual host balancer (byrequest method) chooses between backend1 virtual host and backend2 virtual host"
mkdir -p $AREX_RUN_DIR/htdocs-backend1
echo 'Backend 1' > $AREX_RUN_DIR/htdocs-backend1/index.html
mkdir -p $AREX_RUN_DIR/htdocs-backend2
echo 'Backend 2' > $AREX_RUN_DIR/htdocs-backend2/index.html
for i in $(seq 1 20); do
  curl -s http://localhost:$AREX_RUN_PORT3/
  sleep 0.1
done > $AREX_RUN_DIR/backends-echo.txt
count_backend1=$(grep -c 'Backend 1' $AREX_RUN_DIR/backends-echo.txt)
count_backend2=$(grep -c 'Backend 2' $AREX_RUN_DIR/backends-echo.txt)
echo "Backend 1: $count_backend1 times"
echo "Backend 2: $count_backend2 times"
[ $count_backend1 -ge 7 -a $count_backend2 -ge 7 ] || exit_code=1

exit $exit_code

