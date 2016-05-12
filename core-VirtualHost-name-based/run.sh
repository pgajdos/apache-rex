exit_code=0

echo "[1] get correct index.html"
mkdir -p $AREX_RUN_DIR/htdocs-domain
echo 'DOMAIN server root' > $AREX_RUN_DIR/htdocs-domain/index.html
mkdir -p $AREX_RUN_DIR/htdocs-otherdomain
echo 'OTHERDOMAIN server root' > $AREX_RUN_DIR/htdocs-otherdomain/index.html
curl -s --resolve www.domain.tld:$AREX_PORT:127.0.0.1      http://www.domain.tld:$AREX_PORT/      | grep 'DOMAIN server root'      || exit_code=1
curl -s --resolve www.otherdomain.tld:$AREX_PORT:127.0.0.1 http://www.otherdomain.tld:$AREX_PORT/ | grep 'OTHERDOMAIN server root' || exit_code=1

exit $exit_code

