exit_code=0

echo "[1] VirtualDocumentRoot translates correctly to filesystem"
mkdir -p $AREX_DOCUMENT_ROOT/www.{one.org,second.com,third.net}/
echo "one.org index" > $AREX_DOCUMENT_ROOT/www.one.org/index.html
echo "second.com index" > $AREX_DOCUMENT_ROOT/www.second.com/index.html
mkdir -p $AREX_DOCUMENT_ROOT/www.third.net/site
echo "third.net index" > $AREX_DOCUMENT_ROOT/www.third.net/site/index.html
curl -s --resolve www.one.org:$AREX_RUN_PORT:127.0.0.1    http://www.one.org:$AREX_RUN_PORT/        | grep 'one.org index'    || exit_code=1
curl -s --resolve www.second.com:$AREX_RUN_PORT:127.0.0.1 http://www.second.com:$AREX_RUN_PORT/     | grep 'second.com index' || exit_code=1
curl -s --resolve www.third.net:$AREX_RUN_PORT:127.0.0.1  http://www.third.net:$AREX_RUN_PORT/site/ | grep 'third.net index'  || exit_code=1

echo "[2] more sophisticated translation"
for d in org/{domain/{doc,www},otherdomain/acc}; do
  mkdir -p $AREX_DOCUMENT_ROOT/$d
  echo "$d index" | tr '/' '.' > $AREX_DOCUMENT_ROOT/$d/index.html
done
curl -s --resolve www.domain.org:$AREX_RUN_PORT1:127.0.0.1      http://www.domain.org:$AREX_RUN_PORT1/      | grep 'org.domain.www'      || exit_code=2
curl -s --resolve doc.domain.org:$AREX_RUN_PORT1:127.0.0.1      http://doc.domain.org:$AREX_RUN_PORT1/      | grep 'org.domain.doc'      || exit_code=2
curl -s --resolve acc.otherdomain.org:$AREX_RUN_PORT1:127.0.0.1 http://acc.otherdomain.org:$AREX_RUN_PORT1/ | grep 'org.otherdomain.acc' || exit_code=2

echo "[3] other example: user's pages virtualhosts"
for user in matylda cecilka; do
  mkdir -p $AREX_RUN_DIR/home/$user/public_html
  echo "${user}'s website" > $AREX_RUN_DIR/home/$user/public_html/index.html
done
curl -s --resolve matylda.myplace.org:$AREX_RUN_PORT2:127.0.0.1 http://matylda.myplace.org:$AREX_RUN_PORT2/ | grep "matylda's website" || exit_code=3
curl -s --resolve cecilka.myplace.org:$AREX_RUN_PORT2:127.0.0.1 http://cecilka.myplace.org:$AREX_RUN_PORT2/ | grep "cecilka's website" || exit_code=3

exit $exit_code

