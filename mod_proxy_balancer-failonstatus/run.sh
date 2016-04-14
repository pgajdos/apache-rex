exit_code=0

mkdir -p $AREX_RUN_DIR/htdocs-backend1/foo
echo 'Backend 1' > $AREX_RUN_DIR/htdocs-backend1/index.html
echo 'access forbidden here' > $AREX_RUN_DIR/htdocs-backend1/foo/index.html
mkdir -p $AREX_RUN_DIR/htdocs-backend2/foo
echo 'Backend 2' > $AREX_RUN_DIR/htdocs-backend2/index.html
echo 'access forbidden here' > $AREX_RUN_DIR/htdocs-backend2/foo/index.html

echo "[1] when error code is on failonstatus list, then backend is put in error state for retry=1 second"
# cause 404 error code to put one of the backend in error state
# (404 is on failonstatus list)
curl -s http://localhost:$AREX_RUN_PORT3/notexisting.document
# now only one backend should respond in 1 second, then both
for i in $(seq 1 20); do
  curl -s http://localhost:$AREX_RUN_PORT3/
  sleep 0.1
done > $AREX_RUN_DIR/backends-echo.txt
orphaned_backend=$(tail -n 1 $AREX_RUN_DIR/backends-echo.txt)
count_backend1=$(grep -c 'Backend 1' $AREX_RUN_DIR/backends-echo.txt)
count_backend2=$(grep -c 'Backend 2' $AREX_RUN_DIR/backends-echo.txt)
echo "Orphaned Backend: $orphaned_backend"
echo "Backend 1: $count_backend1 times"
echo "Backend 2: $count_backend2 times"
# when Backend 1 was put on error state (Backend 2 remained orphaned)
# then backend 1 should have little hits and backend 2 more
[ "$orpaned_backend" == "Backend 2" -a $count_backend1 -gt 7 ] && exit_code=1
# and vice versa
[ "$orpaned_backend" == "Backend 1" -a $count_backend2 -gt 7 ] && exit_code=1

# the same as [1], but 403 is not on failonstatus list
echo "[2] when error code is NOT on failonstatus list, then backend is not put in error state"
# cause 403 error
curl -s http://localhost:$AREX_RUN_PORT3/foo/index.html
# both backends should respond
for i in $(seq 1 20); do
  curl -s http://localhost:$AREX_RUN_PORT3/
  sleep 0.1
done > $AREX_RUN_DIR/backends-echo.txt
count_backend1=$(grep -c 'Backend 1' $AREX_RUN_DIR/backends-echo.txt)
count_backend2=$(grep -c 'Backend 2' $AREX_RUN_DIR/backends-echo.txt)
echo "Backend 1: $count_backend1 times"
echo "Backend 2: $count_backend2 times"
[ $count_backend1 -gt 7 -a $count_backend2 -gt 7 ] || exit_code=2

exit $exit_code

