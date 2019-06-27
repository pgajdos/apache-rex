exit_code=0
LogLevel debug

# secret token
SECRET='secret'

mkdir -p $AREX_DOCUMENT_ROOT/protected
echo 'HOLA' > $AREX_DOCUMENT_ROOT/protected/file.txt

echo "[1] direct acces to /protected/ is forbidden"
curl -s http://localhost:$AREX_PORT/protected/file.txt | grep '<title>.*401.*</title>' || exit_code=1

now_hex=$(printf "%x" $(date +%s));
token=$(echo -n "$SECRET/file.txt$now_hex" | md5sum | cut -c -32)

echo "[2] access to /protected/$token/$now_hex/ allowed"
curl -s http://localhost:$AREX_PORT/protected/$token/$now_hex/file.txt | grep 'HOLA' || exit_code=2

exit $exit_code
