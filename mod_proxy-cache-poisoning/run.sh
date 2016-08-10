exit_code=0

mkdir -p $AREX_RUN_DIR/htdocs-victim
echo "Victim's site" > $AREX_RUN_DIR/htdocs-victim/index.html
mkdir -p $AREX_RUN_DIR/htdocs-attack
echo "Attack's site" > $AREX_RUN_DIR/htdocs-attack/index.html

echo "[1] try cache poisoning trough Host: header with reverse proxy"
curl -s -v -H "Host: localhost:$AREX_PORT2" http://localhost:$AREX_PORT3/ \
  2>&1 | grep 'X-Cache\|site\|GET\|Host\|Connected'
curl -s -v http://localhost:$AREX_PORT3/ \
  2>&1 | grep 'X-Cache\|site\|GET\|Host\|Connected'
curl -s -v http://localhost:$AREX_PORT3/ \
  2>&1 | grep 'X-Cache\|site\|GET\|Host\|Connected'

echo
echo "[2] try cache poisoning trough Host: header with forward proxy"
curl -s -v --proxy http://localhost:$AREX_PORT4/ -H "Host: localhost:$AREX_PORT2" http://localhost:$AREX_PORT1/  \
  2>&1 | grep 'X-Cache\|site\|GET\|Host\|Connected'
curl -s -v --proxy http://localhost:$AREX_PORT4/ http://localhost:$AREX_PORT1/ \
  2>&1 | grep 'X-Cache\|site\|GET\|Host\|Connected'

