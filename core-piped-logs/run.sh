exit_code=0

echo "site index" > $AREX_DOCUMENT_ROOT/index.html

echo "[1] there will at least one rotated log"
curl -s http://localhost:$AREX_PORT/ > /dev/null
echo 'wait for log rotation ...'
sleep 2
curl -s http://localhost:$AREX_PORT/ > /dev/null
logfiles=$(find $AREX_RUN_DIR/ -name mylogfile.*)
for lf in $logfiles; do
  echo $lf; cat $lf
done
[ $(echo $logfiles | wc -w) -gt 1 ] || exit_code=1

exit $exit_code
