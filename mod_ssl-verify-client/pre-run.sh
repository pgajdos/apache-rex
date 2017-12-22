# this need to be done before apache start
cp test-server.key test-server.crt test-ca.crt client.crt client.key $AREX_RUN_DIR
mkdir -p $AREX_RUN_DIR/run
