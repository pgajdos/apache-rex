# create password file including internal token to suppress apache 'builtin dialog'
cat << EOF > $AREX_RUN_DIR/password.conf
internal:httptest
EOF

cp -r mod_nss.d $AREX_RUN_DIR/
