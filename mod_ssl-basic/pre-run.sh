#
# create CA certificate and SERVER certificate
#
. ../lib/openssl
mkdir -p $AREX_RUN_DIR/cert
server_name='test'
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

#
# create runtime dir
#
mkdir -p $AREX_RUN_DIR/run
