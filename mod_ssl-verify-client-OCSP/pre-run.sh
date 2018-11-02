#
# create CA, SERVER and CLIENT certificates;
# server and client share the same CA
# https://blog.didierstevens.com/2013/05/08/howto-make-your-own-cert-and-revocation-list-with-openssl/
#
. ../lib/openssl
mkdir -p $AREX_RUN_DIR/cert
echo Setup CA
echo ~~~~~~~~
openssl_setup_ca $AREX_RUN_DIR
echo
echo Setup SERVER 
echo ~~~~~~~~~~~~
openssl_setup_entity $AREX_RUN_DIR aserver.suse.cz
echo
echo Setup CLIENT A
echo ~~~~~~~~~~~~~~
openssl_setup_entity $AREX_RUN_DIR aclient.suse.cz
echo
echo Setup CLIENT B
echo ~~~~~~~~~~~~~~
openssl_setup_entity $AREX_RUN_DIR bclient.suse.cz
echo
echo
echo Creating CRL containing CLIENT A
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
openssl_ca_revoke_cert $AREX_RUN_DIR aclient.suse.cz
echo

#
# create runtime dir, see DefaultRuntimeDir directive
#
mkdir -p $AREX_RUN_DIR/run
