exit_code=0

echo "[1] demonstrate basic RewriteMap usage"
mkdir -p $AREX_RUN_DIR/htdocs-vh1/doc/japanese
mkdir -p $AREX_RUN_DIR/htdocs-vh2/documentation/french
mkdir -p $AREX_RUN_DIR/htdocs-vh3/canadian/doc
echo 'japanese doc index' > $AREX_RUN_DIR/htdocs-vh1/doc/japanese/index.html
echo 'french doc index'   > $AREX_RUN_DIR/htdocs-vh2/documentation/french/index.html
echo 'canadian doc index' > $AREX_RUN_DIR/htdocs-vh3/canadian/doc/index.html
curl -s --location http://localhost:$AREX_PORT/doc/jp/  | grep 'japanese doc index' || exit_code=1
curl -s --location http://localhost:$AREX_PORT/doc/fr/  | grep 'french doc index'   || exit_code=1
curl -s --location http://localhost:$AREX_PORT/doc/can/ | grep 'canadian doc index' || exit_code=1

exit $exit_code

