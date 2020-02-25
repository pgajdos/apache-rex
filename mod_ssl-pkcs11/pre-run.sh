#
# create CA certificate and SERVER certificate
#
. ../lib/openssl
. ../lib/softhsm

echo Setup CA
echo ~~~~~~~~
openssl_setup_ca $AREX_RUN_DIR
echo
echo Setup SERVER 
echo ~~~~~~~~~~~~
openssl_setup_entity $AREX_RUN_DIR aserver.suse.cz
echo

#
# create a softhsm token with server key on it
#
# create the token
echo '--- Initializing softhsm2 ------------------'
success='yes'
softhsm2_create_token "$AREX_RUN_DIR/pkcs11" 'aserver.suse.cz-token' || success='no'
if [ $success == 'yes' ]; then
  echo '--- Done. ----------------------------------'
else
  echo '--- Failed. --------------------------------'
fi
# openssl_setup_entity writes $AREX_RUN_DIR/aserver.suse.cz/private.key in
# PEM format, we need DER
echo 'Converting PEM to DER'
openssl_pem_to_der $AREX_RUN_DIR/aserver.suse.cz/private.key $AREX_RUN_DIR/aserver.suse.cz/private.key.der
openssl_pem_to_der $AREX_RUN_DIR/aserver.suse.cz/my.crt      $AREX_RUN_DIR/aserver.suse.cz/my.crt.der
# load the key in DER format
echo "--- Write private key to token ---------------------"
success='yes'
softhsm2_token_load_file "$AREX_RUN_DIR/pkcs11" 'aserver.suse.cz-token' 010203 $AREX_RUN_DIR/aserver.suse.cz/private.key.der 'aserver.suse.cz-privkey' privkey || success='no'
if [ $success == 'yes' ]; then
  echo '--- Done. ----------------------------------'
else
  echo '--- Failed. --------------------------------'
fi
echo "--- Write certificate to token ---------------------"
success='yes'
softhsm2_token_load_file "$AREX_RUN_DIR/pkcs11" 'aserver.suse.cz-token' 010203 $AREX_RUN_DIR/aserver.suse.cz/my.crt 'aserver.suse.cz-cert' cert || success='no'
if [ $success == 'yes' ]; then
  echo '--- Done. ----------------------------------'
else
  echo '--- Failed. --------------------------------'
fi
# create server environment, need SOFTHSM2_CONF exported
echo "export SOFTHSM2_CONF=\"$AREX_RUN_DIR/pkcs11/softhsm.conf\"" > $AREX_RUN_DIR/server_environment
#
# create runtime dir, see DefaultRuntimeDir directive
#
mkdir -p $AREX_RUN_DIR/run
exit 0
