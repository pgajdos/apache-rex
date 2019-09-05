exit_code=0

. ../lib/openssl

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
echo -n " $(openssl_ocsp_cert_status $AREX_RUN_DIR aserver.suse.cz)"
echo " $(openssl_ocsp_cert_status $AREX_RUN_DIR aclient.suse.cz)"
echo

echo "[1] access for not authentificated client disallowed"
curl --cacert $AREX_RUN_DIR/ca/my.crt \
     --resolve "aserver.suse.cz:$AREX_PORT:127.0.0.1" \
     https://aserver.suse.cz:$AREX_PORT/ 2>&1 \
  | grep 'handshake failure' || exit_code=1

echo "[2] client's certificate was revoked, connection refused"
curl --cacert $AREX_RUN_DIR/ca/my.crt \
     --cert   $AREX_RUN_DIR/aclient.suse.cz/my.crt \
     --key    $AREX_RUN_DIR/aclient.suse.cz/private.key  \
     --resolve "aserver.suse.cz:$AREX_PORT:127.0.0.1" https://aserver.suse.cz:$AREX_PORT/ 2>&1 \
  | grep 'certificate revoked' || exit_code=2
  grep 'certificate revoked' $AREX_RUN_DIR/error_log || exit_code=2

echo "[3] client correctly verified"
curl -s --cacert $AREX_RUN_DIR/ca/my.crt \
        --cert   $AREX_RUN_DIR/bclient.suse.cz/my.crt \
        --key    $AREX_RUN_DIR/bclient.suse.cz/private.key  \
        --resolve "aserver.suse.cz:$AREX_PORT:127.0.0.1" https://aserver.suse.cz:$AREX_PORT/ \
  | grep 'Test SSL' || exit_code=3


echo
echo -n 'Stopping OCSP responder ... '
openssl_ocsp_responder_stop $AREX_RUN_DIR && echo 'done.' || echo 'FAILED.'
 
exit $exit_code
