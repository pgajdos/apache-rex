exit_code=0

echo "[1] rate limited to 1024B/s"
printf '=%.s' {1..2048} > $AREX_DOCUMENT_ROOT/data
curl --max-time 1 http://localhost:$AREX_RUN_PORT/data 2>&1 | grep 'Operation timed out' || exit_code=1

exit $exit_code
