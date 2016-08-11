exit_code=0

cgi_dir=$AREX_RUN_DIR/cgi-bin
mkdir -p  $cgi_dir

echo "[1] correct cgi script"
install -m 755 printenv.pl $AREX_RUN_DIR/cgi-bin
# httpd should not export HTTP_PROXY with value from the Proxy: header (see DESCRIPTION)
curl -s -H 'Proxy: attack.org' http://localhost:$AREX_PORT/cgi-bin/printenv.pl | grep 'HTTP_PROXY' && exit_code=1

exit $exit_code

