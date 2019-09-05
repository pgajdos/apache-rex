exit_code=0

. ../lib/openssl
. ../lib/processman

echo 'Test SSL, restricted area' > $AREX_DOCUMENT_ROOT/index.html

echo -n 'Starting OCSP responder daemon .. '
openssl_ocsp_responder_start $AREX_RUN_DIR
ocspr_pid=$(get_pid_port $AREX_OCSP_PORT)
if [ -z "$ocspr_pid" ]; then
  echo FAILED.
  exit 1
fi
echo $ocspr_pid
echo -n 'Checking the OCSP responder is working:'
echo " $(openssl_ocsp_cert_status $AREX_RUN_DIR aserver.suse.cz)"
echo

echo "[1] server has a valid certificate"
status=$(openssl_ocsp_cert_status $AREX_RUN_DIR aserver.suse.cz)
echo "Certificate is $status, let us do curl!"
curl -s --cert-status \
        --cacert $AREX_RUN_DIR/ca/my.crt \
        --resolve "aserver.suse.cz:$AREX_PORT:127.0.0.1" \
        https://aserver.suse.cz:$AREX_PORT/ \
    | grep 'Test SSL, restricted area' || exit_code=1
echo
echo Revoking certificate for aserver.suse.cz
echo ----------------------------------------
openssl_ca_revoke_cert $AREX_RUN_DIR aserver.suse.cz
echo
echo Restarting OCSP responder
echo -------------------------
echo -n 'Stopping OCSP responder ... '
openssl_ocsp_responder_stop $AREX_RUN_DIR && echo 'done.' || echo 'FAILED.'
echo -n 'Starting OCSP responder daemon .. '
openssl_ocsp_responder_start $AREX_RUN_DIR
ocspr_pid=$(get_pid_port $AREX_OCSP_PORT)
if [ -z "$ocspr_pid" ]; then
  echo FAILED.
  exit 1
fi
echo $ocspr_pid
sleep 1
echo -n 'Checking the certificate:'
echo " $(openssl_ocsp_cert_status $AREX_RUN_DIR aserver.suse.cz)"
echo
echo "[2] server has a revoked certificate"
status=$(openssl_ocsp_cert_status $AREX_RUN_DIR aserver.suse.cz)
curl --cert-status \
     --cacert $AREX_RUN_DIR/ca/my.crt \
     --resolve "aserver.suse.cz:$AREX_PORT:127.0.0.1" \
     https://aserver.suse.cz:$AREX_PORT/ 2>&1 \
    | grep 'certificate revocation reason' || exit_code=2
grep 'response has certificate status revoked' $AREX_RUN_DIR/error_log || exit_code=2
echo
echo -n 'Stopping OCSP responder ... '
openssl_ocsp_responder_stop $AREX_RUN_DIR && echo 'done.' || echo 'FAILED.'
 
exit $exit_code
