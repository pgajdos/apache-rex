exit_code=0

htpasswd -bc $AREX_RUN_DIR/password-file admin       StrongAdminPassword
mkdir -p "$AREX_DOCUMENT_ROOT/dav"

echo "welcome to the project" > $AREX_RUN_DIR/welcome.html

echo "[1] create welcome.html in /dav location"
curl -s -u admin:StrongAdminPassword --upload-file $AREX_RUN_DIR/welcome.html \
     http://localhost:$AREX_PORT/dav/welcome.html > /dev/null
curl -s http://localhost:$AREX_PORT/dav/welcome.html \
  | grep 'welcome to the project' || exit_code=1

echo "[2] create project dir in /dav"
curl -s -u admin:StrongAdminPassword -X MKCOL http://localhost:$AREX_PORT/dav/project > /dev/null
ls -d $AREX_DOCUMENT_ROOT/dav/project || exit_code=2

echo "[3] move welcome.html from /dav to /dav/project"
curl -s -u admin:StrongAdminPassword -X MOVE \
     --header "Destination: http://localhost:$AREX_PORT/dav/project/welcome.html" \
     http://localhost:$AREX_PORT/dav/welcome.html > /dev/null
curl -s http://localhost:$AREX_PORT/dav/project/welcome.html \
  | grep 'welcome to the project' || exit_code=3

echo "[4] list /dav and /dav/project dirs"
curl -s -X PROPFIND --header "Depth: 1" http://localhost:$AREX_PORT/dav/ \
  | grep welcome.html && exit_code=5
curl -s -X PROPFIND --header "Depth: 1" http://localhost:$AREX_PORT/dav/project/ \
  | grep welcome.html || exit_code=5

exit $exit_code

