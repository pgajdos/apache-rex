exit_code=0

curl -s http://127.0.0.1:$AREX_PORT/crash -o $AREX_RUN_DIR/mod_crash.txt || true
curl -s -o $AREX_RUN_DIR/mod_backtrace.txt http://localhost:60080/backtrace

echo '[1] mod_crash output'
grep 'Crashing in process'  $AREX_RUN_DIR/mod_crash.txt || exit_code=1
grep 'about to crash'       $AREX_RUN_DIR/error_log     || exit_code=1

echo '[2] mod_backtrace output in error_log'
grep 'backtrace.*0x' $AREX_RUN_DIR/error_log || exit_code=2

echo '[3] mod_backtrace output in /backtrace'
grep 'mod_backtrace: DIAG_BTFIELDS_FUNCTION' $AREX_RUN_DIR/mod_backtrace.txt || exit_code=3
grep 'ap_run_handler'                        $AREX_RUN_DIR/mod_backtrace.txt || exit_code=3

echo '[4] test mod_whatkilledus output in wku_log'
grep 'Crash at'          $AREX_RUN_DIR/wku_log || exit_code=4
grep 'Fatal signal: 11'  $AREX_RUN_DIR/wku_log || exit_code=4
grep 'libc.*0x'          $AREX_RUN_DIR/wku_log || exit_code=4
grep 'Request line'      $AREX_RUN_DIR/wku_log || exit_code=4

echo '[5] test diagnostic_filter output in error_log'
cat << EOF > $AREX_DOCUMENT_ROOT/test-mod-diagnostics.html
have lot of fun
EOF
curl -s -o $AREX_RUN_DIR/mod_diagnostics.txt http://localhost:$AREX_PORT/test-mod-diagnostics.html
grep 'o-resource-1 FILE'   $AREX_RUN_DIR/error_log || exit_code=5
grep 'o-resource-2 MMAP'   $AREX_RUN_DIR/error_log || exit_code=5

exit $exit_code
