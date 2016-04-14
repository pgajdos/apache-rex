exit_code=0

echo index >  $AREX_DOCUMENT_ROOT/index.html

echo "[1] dumpio log"
curl -s http://localhost:$AREX_RUN_PORT/
grep 'mod_dumpio:  dumpio_in (data-HEAP): Host: localhost' $AREX_RUN_DIR/error_log || exit_code=1
grep 'mod_dumpio:  dumpio_out (data-MMAP): index'          $AREX_RUN_DIR/error_log || exit_code=1


exit $exit_code
