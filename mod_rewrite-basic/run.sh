exit_code=0

for g in strategy sport; do
  mkdir -p $AREX_RUN_DIR/mirror/$g
  echo "$g Index" > $AREX_RUN_DIR/mirror/$g/index.html
done
echo "Game Index" > $AREX_RUN_DIR/mirror/index.html
for i in 1 2; do
  mkdir -p $AREX_RUN_DIR/htdocs-backend/dir$i
  echo "Game $i" > $AREX_RUN_DIR/htdocs-backend/dir$i/index.html
done

# see https://httpd.apache.org/docs/trunk/rewrite/intro.html

echo "[1] alias to filesystem path"
curl -s --location http://localhost:$AREX_RUN_PORT/games/          | grep 'Game Index'     || exit_code=1
curl -s --location http://localhost:$AREX_RUN_PORT/games/strategy/ | grep 'strategy Index' || exit_code=1
curl -s --location http://localhost:$AREX_RUN_PORT/games/sport/    | grep 'sport Index'    || exit_code=1
echo "[2] web-path to resource"
curl -s --location http://localhost:$AREX_RUN_PORT/play/           | grep 'Game Index'     || exit_code=2
echo "[3] wrong order of RewriteRule-s"
curl -s --location http://localhost:$AREX_RUN_PORT/play-wrong/     | grep '404 Not Found'  || exit_code=2
echo "[4] an absolute url"
curl -s --location http://localhost:$AREX_RUN_PORT/game1/          | grep 'Game 1'         || exit_code=3
curl -s --location http://localhost:$AREX_RUN_PORT/game2/          | grep 'Game 2'         || exit_code=3

exit $exit_code

