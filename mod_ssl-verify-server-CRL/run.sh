exit_code=0

. ../lib/openssl

echo 'Test SSL' > $AREX_DOCUMENT_ROOT/index.html

echo "[1] access trough https allowed"
curl -s --cacert $AREX_RUN_DIR/ca/my.crt \
        --resolve "aserver.suse.cz:$AREX_PORT:127.0.0.1" \
        https://aserver.suse.cz:$AREX_PORT/ \
    | grep 'Test SSL' || exit_code=1

# create crl file with aserver.suse.cz certificate
echo
echo Revoking certificate for aserver.suse.cz
echo ----------------------------------------
openssl_ca_revoke_cert $AREX_RUN_DIR aserver.suse.cz
echo

echo "[2] access trough http disallowed"
curl --crlfile $AREX_RUN_DIR/ca/my.crl \
        --cacert $AREX_RUN_DIR/ca/my.crt \
        --resolve "aserver.suse.cz:$AREX_PORT:127.0.0.1" \
        https://aserver.suse.cz:$AREX_PORT/ 2>&1 \
    | grep 'certificate revoked' || exit_code=2

exit $exit_code
