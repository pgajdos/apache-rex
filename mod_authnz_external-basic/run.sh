exit_code=0
LogLevel debug

# secret token
SECRET='secret'

mkdir -p $AREX_DOCUMENT_ROOT/protected
echo 'RESTRICTED AREA' > $AREX_DOCUMENT_ROOT/protected/index.html

echo "[1] acces to /protected/ without password is forbidden"
curl -s http://localhost:$AREX_PORT/protected/ | grep '<title>.*401.*</title>' || exit_code=1

echo "[2] acces to /protected/ with incorrect password is forbidden"
curl -u wilma:betty -s http://localhost:$AREX_PORT/protected/ | grep '<title>.*401.*</title>' || exit_code=2

echo "[3] access to /protected/ with correct password is allowed"
curl -u wilma:wilma -s http://localhost:$AREX_PORT/protected/ | grep 'RESTRICTED AREA' || exit_code=3

exit $exit_code
