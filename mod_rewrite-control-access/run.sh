exit_code=0

echo "[1] mitigate (not exclude) image hotlinking"
mkdir -p $AREX_RUN_DIR/htdocs-vh1
for i in go-away image; do
  echo "$i" > $AREX_RUN_DIR/htdocs-vh1/$i.png
done
# we will get image when referer not set
curl -s http://localhost:$AREX_PORT1/image.png | grep 'image' || exit_code=1
# we will get image when referer is our domain
curl -s --referer www.ourdomain.org http://localhost:$AREX_PORT1/image.png | grep 'image' || exit_code=1
curl -s --location --referer www.theirdomain.org http://localhost:$AREX_PORT1/image.png | grep 'go-away' || exit_code=1

echo "[2] denying hosts in a blacklist"
mkdir -p $AREX_RUN_DIR/htdocs-vh2
echo 'allowed' > $AREX_RUN_DIR/htdocs-vh2/index.html
curl -s http://127.0.0.1:$AREX_PORT2/ | grep '403 Forbidden' || exit_code=2

exit $exit_code

