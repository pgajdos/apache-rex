exit_code=0

echo "[1] error_log contains specified format"
cat $AREX_RUN_DIR/error_log | grep "[MYLOGFORMAT].*[MYLOGFORMAT]" || exit_code=1

exit $exit_code
