exit_code=0
grep 'mod_ssl loaded, but SSL flag not defined' $AREX_RUN_DIR/start_log || exit_code=1
exit $exit_code
