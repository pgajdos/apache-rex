#
# create CA, SERVER and CLIENT certificates;
# server and client share the same CA
#
. ../lib/openssl
mkdir -p $AREX_RUN_DIR/cert
server_name='test'
client_name='joe'
echo Generating CA certificate
echo ~~~~~~~~~~~~~~~~~~~~~~~~~
# create CA key
openssl_key $AREX_RUN_DIR/cert/test-ca.key
# create CA certificate using CA key
openssl_ca_cert $AREX_RUN_DIR/cert/test-ca.key $AREX_RUN_DIR/cert/test-ca.crt 'trustworthy-ca'
echo
echo Generating SERVER certificate
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
echo Generating CLIENT certificate
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# create CLIENT key
openssl_key $AREX_RUN_DIR/cert/test-client.key
# create CLIENT signing request using CLIENT key
openssl_client_csr $AREX_RUN_DIR/cert/test-client.key $AREX_RUN_DIR/cert/test-client.csr $client_name
# create CLIENT certificate using CA key and certificate and CLIENT signing request
openssl_client_cert $AREX_RUN_DIR/cert/test-ca.crt \
                    $AREX_RUN_DIR/cert/test-ca.key \
                    $AREX_RUN_DIR/cert/test-client.csr \
                    $AREX_RUN_DIR/cert/test-client.crt \
                    $client_name

#
# create runtime dir, see DefaultRuntimeDir directive
#
mkdir -p $AREX_RUN_DIR/run
