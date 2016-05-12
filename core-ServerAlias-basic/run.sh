exit_code=0

for i in 1 2; do
  mkdir -p $AREX_RUN_DIR/htdocs-vh$i
  echo "it works $i" > $AREX_RUN_DIR/htdocs-vh$i/index.html
done
echo "[1] demonstrate aliased hostname"
curl -s --location --resolve www.domain.com:$AREX_PORT:127.0.0.1 http://www.domain.com:$AREX_PORT/ | grep 'it works 1' || exit_code=1
echo "[2] demonstrate wildcard in alias"
curl -s --location --resolve doc.otherdomain.com:$AREX_PORT:127.0.0.1 http://doc.otherdomain.com:$AREX_PORT/ | grep 'it works 2' || exit_code=2

exit $exit_code
