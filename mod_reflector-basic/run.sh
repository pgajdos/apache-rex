exit_code=0

echo "[1] filter data trough simple filter and get them back"
curl -s -X POST -d 'It does not work!' http://localhost:$AREX_PORT/fix | grep 'It works!' || exit_code=1

exit $exit_code
