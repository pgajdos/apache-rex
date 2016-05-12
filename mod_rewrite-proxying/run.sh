exit_code=0

echo "[1] proxying content with mod_rewrite (demonstrate [P] option)"
mkdir -p $AREX_RUN_DIR/htdocs-vh{1,2}
echo 'superfluous document' > $AREX_RUN_DIR/htdocs-vh1/foo.html
echo 'old version document' > $AREX_RUN_DIR/htdocs-vh1/bar.html
echo 'new version document' > $AREX_RUN_DIR/htdocs-vh2/bar.html
curl -s http://localhost:$AREX_PORT2/foo.html | grep 'superfluous document' || exit_code=1
curl -s http://localhost:$AREX_PORT2/bar.html | grep 'old version document' || exit_code=1

exit $exit_code
