#
# create CA certificate and SERVER certificate
#
. ../lib/openssl
echo Setup CA
echo ~~~~~~~~
openssl_setup_ca $AREX_RUN_DIR
echo
echo Setup SERVER 
echo ~~~~~~~~~~~~
openssl_setup_entity $AREX_RUN_DIR frontend.su.se
openssl_setup_entity $AREX_RUN_DIR backend.su.se
echo
#
# create runtime dir, see DefaultRuntimeDir directive
#
mkdir -p $AREX_RUN_DIR/run
