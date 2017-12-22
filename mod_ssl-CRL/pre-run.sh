#
# create CA, SERVER and CLIENT certificates;
# server and client share the same CA
#
. ../lib/openssl
mkdir -p $AREX_RUN_DIR/cert
echo Generating CA certificate
echo ~~~~~~~~~~~~~~~~~~~~~~~~~
# create CA key
openssl_key $AREX_RUN_DIR/cert/test-ca.key
# create CA certificate using CA key
openssl_ca_cert $AREX_RUN_DIR/cert/test-ca.key $AREX_RUN_DIR/cert/test-ca.crt 'trustworthy-ca'
echo
echo Generating SERVER certificate
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
server_name='test'
# create SERVER key
openssl_key $AREX_RUN_DIR/cert/test-server.key
# create SERVER signing request using SERVER key
openssl_server_csr $AREX_RUN_DIR/cert/test-server.key $AREX_RUN_DIR/cert/test-server.csr $server_name
# create SERVER certificate using CA key and certificate and SERVER signing request
openssl_server_cert $AREX_RUN_DIR/cert/test-ca.crt \
                    $AREX_RUN_DIR/cert/test-ca.key \
                    $AREX_RUN_DIR/cert/test-server.csr \
                    $AREX_RUN_DIR/cert/test-server.crt \
                    $server_name
echo
echo Generating CLIENT A certificate
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
client_name='joe'
# create CLIENT A key
openssl_key $AREX_RUN_DIR/cert/test-clientA.key
# create CLIENT A signing request using CLIENT A key
openssl_client_csr $AREX_RUN_DIR/cert/test-clientA.key $AREX_RUN_DIR/cert/test-clientA.csr $client_name
# create CLIENT A certificate using CA key and certificate and CLIENT A signing request
openssl_client_cert $AREX_RUN_DIR/cert/test-ca.crt \
                    $AREX_RUN_DIR/cert/test-ca.key \
                    $AREX_RUN_DIR/cert/test-clientA.csr \
                    $AREX_RUN_DIR/cert/test-clientA.crt \
                    $client_name

echo
echo Generating CLIENT B certificate
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
client_name='jeff'
# create CLIENT B key
openssl_key $AREX_RUN_DIR/cert/test-clientB.key
# create CLIENT B signing request using CLIENT B key
openssl_client_csr $AREX_RUN_DIR/cert/test-clientB.key $AREX_RUN_DIR/cert/test-clientB.csr $client_name
# create CLIENT B certificate using CA key and certificate and CLIENT B signing request
openssl_client_cert $AREX_RUN_DIR/cert/test-ca.crt \
                    $AREX_RUN_DIR/cert/test-ca.key \
                    $AREX_RUN_DIR/cert/test-clientB.csr \
                    $AREX_RUN_DIR/cert/test-clientB.crt \
                    $client_name

echo
echo Creating CRL containing CLIENT A
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# create CA configuration, seem to be neccessary to
# create CRL, see lib/openssl or e. g.
# https://blog.didierstevens.com/2013/05/08/howto-make-your-own-cert-and-revocation-list-with-openssl/
openssl_ca_create_conf $AREX_RUN_DIR/cert/test-ca.crt \
                       $AREX_RUN_DIR/cert/test-ca.key \
                       $AREX_RUN_DIR/cert/test-ca.crl
openssl_ca_revoke_cert $AREX_RUN_DIR/cert/test-ca.crl \
                       $AREX_RUN_DIR/cert/test-clientA.crt
echo

#
# create runtime dir, see DefaultRuntimeDir directive
#
mkdir -p $AREX_RUN_DIR/run
