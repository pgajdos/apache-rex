exit_code=0

mkdir -p $AREX_RUN_DIR/htdocs-backend1
echo 'Backend 1' > $AREX_RUN_DIR/htdocs-backend1/index.html
printf '#!/bin/bash\necho Wrong Script' > $AREX_RUN_DIR/htdocs-backend1/wrong.cgi
mkdir -p $AREX_RUN_DIR/htdocs-backend2
echo 'Backend 2' > $AREX_RUN_DIR/htdocs-backend2/index.html
printf '#!/bin/bash\necho Wrong Script' > $AREX_RUN_DIR/htdocs-backend2/wrong.cgi

echo "[1] 500 is NOT on failonstatus list, backend should not be put in error state"
# cause 500 error
curl -s http://localhost:$AREX_RUN_PORT3/wrong.cgi
# both backends should respond
for i in $(seq 1 20); do
  curl -s http://localhost:$AREX_RUN_PORT3/
  sleep 0.1
done > $AREX_RUN_DIR/backends-echo.txt
count_backend1=$(grep -c 'Backend 1' $AREX_RUN_DIR/backends-echo.txt)
count_backend2=$(grep -c 'Backend 2' $AREX_RUN_DIR/backends-echo.txt)
echo "Backend 1: $count_backend1 times"
echo "Backend 2: $count_backend2 times"
[ $count_backend1 -gt 7 -a $count_backend2 -gt 7 ] || exit_code=1

exit $exit_code

