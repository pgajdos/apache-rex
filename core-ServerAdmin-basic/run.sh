exit_code=0

# this should return error message with the contact
echo "[1] ServerAdmin contact inside (custom) error message"
curl -s http://localhost:$AREX_RUN_PORT/ | grep 'not found, contact i@apache.org if it should exist' || exit_code=1

exit $exit_code
