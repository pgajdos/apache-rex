exit_code=0

echo "[1] show footer of 404"
curl -s http://localhost:$AREX_RUN_PORT/ | grep "<address>Apache/[0-9\.]*\(-dev\)\? (Linux/SUSE) Server at localhost Port $AREX_RUN_PORT</address>" || exit_code=1

exit $exit_code

