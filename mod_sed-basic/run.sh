exit_code=0

echo "[1] Sed output filter rewrites html document content"
echo 'It does not work!' > $AREX_DOCUMENT_ROOT/index.html
curl -s http://localhost:$AREX_RUN_PORT/ | grep 'It works!' || exit_code=1

echo "[2] Sed input filter rewrites POST data"
mkdir -p $AREX_DOCUMENT_ROOT/cgi
cat << EOF > $AREX_DOCUMENT_ROOT/cgi/echo-post-data.cgi
#!/bin/bash
echo "Content-type: text/html"
echo ""
read -n \$CONTENT_LENGTH data; echo \$data
EOF
chmod 755 $AREX_DOCUMENT_ROOT/cgi/echo-post-data.cgi
echo 'It does not work!' > $AREX_RUN_DIR/POST.data
curl -s -X POST -d @$AREX_RUN_DIR/POST.data http://localhost:$AREX_RUN_PORT/cgi/echo-post-data.cgi | grep 'It works!' || exit_code=2

exit $exit_code
