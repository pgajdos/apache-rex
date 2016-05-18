exit_code=0

cp hooks.lua $AREX_RUN_DIR

echo "[1] custom input filter rewrites POST data"
cat << EOF > $AREX_DOCUMENT_ROOT/echo-post-data.cgi
#!/bin/bash
echo "Content-type: text/html"
echo ""
# we added something in the lua hook
read -n \$((CONTENT_LENGTH + 20)) data; echo \$data
EOF
chmod 755 $AREX_DOCUMENT_ROOT/echo-post-data.cgi
curl -s --data "action=getimage&old_parameter=3k" "http://localhost:$AREX_PORT/echo-post-data.cgi" | grep 'new_syntax=yes' || exit_code=1

exit $exit_code
