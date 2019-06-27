exit_code=0

echo "[1] limit bandwith in a Directory"
yes 'This is really loooooooooong file.' | head -n 10 > $AREX_DOCUMENT_ROOT/longfile.html
(time curl -s http://localhost:$AREX_PORT/longfile.html) &>$AREX_RUN_DIR/output.txt
seconds=$(cat $AREX_RUN_DIR/output.txt | grep '^real' |  sed 's:.*0m\([0-9]\+\)\..*:\1:')

echo Request took: $seconds
[ "$seconds" -ge 3 ] || exit_code=1
grep 'Rate : 100 Minimum : 100' $AREX_RUN_DIR/error_log || exit_code=1

exit $exit_code

