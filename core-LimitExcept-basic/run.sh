exit_code=0

htpasswd -bc $AREX_RUN_DIR/password-file admin       StrongAdminPassword
echo 'main index' > $AREX_DOCUMENT_ROOT/index.html

echo "[1] GET allowed for all, other methods only for admin"
curl -s -X GET                               http://localhost:$AREX_RUN_PORT/ | grep 'main index'    || exit_code=1
curl -s -X POST                              http://localhost:$AREX_RUN_PORT/ | grep '401.*uthoriz'  || exit_code=1
curl -s -X POST -u admin:StrongAdminPassword http://localhost:$AREX_RUN_PORT/ | grep 'main index'    || exit_code=1

exit $exit_code

