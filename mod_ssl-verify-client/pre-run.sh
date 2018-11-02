#
# create CA, SERVER and CLIENT certificates;
# server and client share the same CA
#
. ../lib/openssl
echo Setup CA
echo ~~~~~~~~
openssl_setup_ca $AREX_RUN_DIR
echo
echo Setup SERVER 
echo ~~~~~~~~~~~~
openssl_setup_entity $AREX_RUN_DIR aserver.suse.cz
echo
echo Setup CLIENT
echo ~~~~~~~~~~~~
openssl_setup_entity $AREX_RUN_DIR aclient.suse.cz
echo

#
# create runtime dir, see DefaultRuntimeDir directive
#
mkdir -p $AREX_RUN_DIR/run
