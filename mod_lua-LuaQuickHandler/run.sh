exit_code=0

cp hooks.lua $AREX_RUN_DIR/

echo 'server is down to maintenance, please try again later' > $AREX_DOCUMENT_ROOT/under-maintenance.txt
mkdir -p $AREX_DOCUMENT_ROOT/administration/
echo "welcome, administrator!" > $AREX_DOCUMENT_ROOT/administration/index.html
echo "welcome, user!"          > $AREX_DOCUMENT_ROOT/index.html

echo "[1] server is accessible for administration tasks"
curl -s http://127.0.0.1:$AREX_RUN_PORT/administration  | grep 'welcome, administrator!' || exit_code=1

echo "[2] requests to other locations are declined"
curl -s http://127.0.0.1:$AREX_RUN_PORT/ | grep 'down to maintenance' || exit_code=2

echo "[3] requests from other address then 127.0.0.1 are declined"
curl -s http://[::1]:$AREX_RUN_PORT/administration | grep 'down to maintenance' || exit_code=3

exit $exit_code
