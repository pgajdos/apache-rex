exit_code=0

echo "[1] custom input filter rewrites POST data"
cat << EOF > $AREX_DOCUMENT_ROOT/echo-post-data.cgi
#!/bin/bash
echo "Content-type: text/html"
echo ""
read -n \$CONTENT_LENGTH data; echo \$data
EOF
chmod 755 $AREX_DOCUMENT_ROOT/echo-post-data.cgi
echo 'It does not work!' > $AREX_RUN_DIR/POST.data
curl -s -X POST -d @$AREX_RUN_DIR/POST.data http://localhost:$AREX_PORT/echo-post-data.cgi | grep 'It works!' || exit_code=1

exit $exit_code

