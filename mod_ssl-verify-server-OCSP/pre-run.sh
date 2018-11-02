#
# create CA and SERVER certificates
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

#
# create runtime dir, see DefaultRuntimeDir directive
#
mkdir -p $AREX_RUN_DIR/run
