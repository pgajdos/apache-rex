exit_code=0

echo "[1] error_log contains specified format"
cat $AREX_RUN_DIR/error_log | grep "[MYLOGFORMAT].*[MYLOGFORMAT]" || exit_code=1

echo "[2] server time (time in an error_log) timezone matches system one"
servertimesec=$(tail -n 1 $AREX_RUN_DIR/error_log | sed 's:.*[DATE]\(.*\)[DATE].*::' | date +%s)
systemtimesec=$(date +%s)
difference=$((systemtimesec-servertimesec))
echo $servertimesec - $systemtimesec = $difference
[ $difference -lt 5 ] || exit_code=2

exit $exit_code
