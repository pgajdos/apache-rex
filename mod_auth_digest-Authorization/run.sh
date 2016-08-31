exit_code=0

# this is just elaborated mod_auth_digest-basic without curl's --digest:
# curl --digest -u john:StrongPassword -s http://localhost:$AREX_PORT/ | grep 'Secret DATA' || exit_code=1

echo 'Secret DATA' > $AREX_DOCUMENT_ROOT/index.html
uri=/index.html
user=john
password=StrongPassword

echo "[1] access granted with correct username and correct password"
curl -s -i http://localhost:$AREX_PORT/index.html > $AREX_RUN_DIR/401-response
authenticate_header=$(grep 'WWW-Authenticate:' $AREX_RUN_DIR/401-response)
auth_realm=$(echo $authenticate_header | sed 's:.*realm="\([^"]*\)".*:\1:')
auth_nonce=$(echo $authenticate_header | sed 's:.*nonce="\([^"]*\)".*:\1:')
# will be MD5, MD5-sess is not implemented in apache httpd
auth_algorithm=$(echo $authenticate_header | sed 's:.*algorithm="\([^"]*\)".*:\1:')
# will be auth, auth-int is not implemented in apache httpd
auth_qop=$(echo $authenticate_header | sed 's:.*qop="\([^"]*\)".*:\1:')
echo "realm:     $auth_realm"
echo "nonce:     $auth_nonce"
echo "algorithm: $auth_algorithm"
echo "qop:       $auth_qop"

# calculate response, see
# https://en.wikipedia.org/wiki/Digest_access_authentication
function md5() { echo -n $1 | md5sum | sed "s: .*::"; }
auth_ha1=$(md5 "$user:$auth_realm:$password")
echo "HA1: $auth_ha1"
auth_ha2=$(md5 "GET:$uri")
echo "HA2: $auth_ha2"
auth_cnonce='0a4f113b' # client nonce, something, new for each request
auth_nc='00000001'     # in next request has to be greater for given server nonce
auth_response=$(md5 "$auth_ha1:$auth_nonce:$auth_nc:$auth_cnonce:auth:$auth_ha2")
echo "response:  $auth_response"
echo

# get the data!
curl -s -i \
     -H "Authorization: Digest username=\"$user\", realm=\"$auth_realm\", nonce=\"$auth_nonce\", uri=\"$uri\", qop=\"$auth_qop\", nc=\"$auth_nc\", cnonce=\"$auth_cnonce\", response=\"$auth_response\"" \
     http://localhost:$AREX_PORT/index.html > $AREX_RUN_DIR/200-response

grep 'Secret DATA' $AREX_RUN_DIR/200-response || exit_code=1
grep "Authentication-Info.*$cnounce" $AREX_RUN_DIR/200-response || exit_code=1

exit $exit_code
