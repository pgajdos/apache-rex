exit_code=0

mkdir -p $AREX_RUN_DIR/htdocs-internal{1,2}
echo "<a href="http://localhost:$AREX_RUN_PORT1/help.html">HELP backend 1" > $AREX_RUN_DIR/htdocs-internal1/index.html
echo "<a href="http://localhost:$AREX_RUN_PORT2/help.html">HELP backend 2" > $AREX_RUN_DIR/htdocs-internal2/index.html
curl -s --resolve www.frontend.com:$AREX_RUN_PORT:127.0.0.1 http://www.frontend.com:$AREX_RUN_PORT/app1/index.html > out-mapped.txt

echo "[1] links mapped when requested"
grep '/app1/help.html' out-mapped.txt || exit_code=1

echo "[2] essential tags added"
grep '<body>' out-mapped.txt || exit_code=2

echo "[3] closing tag added"
grep '</a>' out-mapped.txt || exit_code=3
curl -s --resolve www.frontend.com:$AREX_RUN_PORT:127.0.0.1 http://www.frontend.com:$AREX_RUN_PORT/app2/index.html > out-not-mapped.txt

echo "[4] links not mapped"
grep 'localhost' out-not-mapped.txt

exit $exit_code
