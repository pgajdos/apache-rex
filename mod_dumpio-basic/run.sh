exit_code=0

echo 'my index' >  $AREX_DOCUMENT_ROOT/index.html

echo "[1] dumpio log of simple GET"
curl -H 'Range: bytes=4-8' -s "http://localhost:$AREX_PORT/?genus-name=ips&species-name=duplicatus"
echo REQUEST
grep 'dumpio_in (data'  $AREX_RUN_DIR/error_log
echo RESPONSE
grep 'dumpio_out (data' $AREX_RUN_DIR/error_log
echo
grep 'mod_dumpio:  dumpio_in .*: Host: localhost' $AREX_RUN_DIR/error_log || exit_code=1
grep 'mod_dumpio:  dumpio_out .*: ndex'           $AREX_RUN_DIR/error_log || exit_code=1

exit $exit_code
