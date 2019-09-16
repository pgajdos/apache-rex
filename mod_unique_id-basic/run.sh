exit_code=0

echo "[1] UNIQUE_ID is set to '[A-Za-z0-9@-]*' string"
echo 'main index' > $AREX_DOCUMENT_ROOT/index.html
curl -s http://localhost:$AREX_PORT/ >/dev/null
grep '^[A-Za-z0-9@-]* .*' $AREX_RUN_DIR/access_log || exit_code=1
unique_id=$(head -n 1 $AREX_RUN_DIR/access_log | cut -d' ' -f1)

echo
echo "[2] UNIQUE_ID is also used as forensic_log identifier"
grep $unique_id $AREX_RUN_DIR/forensic_log || exit_code=2

echo
echo "[3] UNIQUE_ID can be used also in error_log: as %L in ErrorLogFormat or in LogMessage (%{env: UNIQUE_ID})"
grep "$unique_id|.*Request: $unique_id" $AREX_RUN_DIR/error_log || exit_code=3

exit $exit_code
