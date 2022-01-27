# available document roots have to exist before server starts
mkdir -p $AREX_DOCUMENT_ROOT/{foo,bar}
# create server environment, SITE env variable will be used in configuration
echo "export SITE=bar" > $AREX_RUN_DIR/server_environment
