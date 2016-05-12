exit_code=0

cgi_dir=$AREX_RUN_DIR/cgi-bin
mkdir -p  $cgi_dir

# this should return error message with the contact
echo "[1] ServerAdmin contact accessible trough SERVER_ADMIN internal variable"
cat << EOF > $cgi_dir/server-admin.cgi
#!/bin/bash
echo 'Content-type: text/html'
echo ''
echo "server admin: \$SERVER_ADMIN"
EOF
chmod 755 $cgi_dir/server-admin.cgi
curl -s http://localhost:$AREX_PORT/cgi-bin/server-admin.cgi | grep 'server admin: i@apache.org' || exit_code=1


exit $exit_code
