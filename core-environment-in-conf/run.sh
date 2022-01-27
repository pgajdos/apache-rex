exit_code=0

echo 'Foo Site Index' > $AREX_DOCUMENT_ROOT/foo/index.html
echo 'Bar Site Index' > $AREX_DOCUMENT_ROOT/bar/index.html

echo "[1] get correct index.html"
# current site is chosen by SITE env variable in pre-run.sh
curl -s http://localhost:$AREX_PORT/ | grep 'Bar Site' || exit_code=1

exit $exit_code

