exit_code=0

cp hooks.lua $AREX_RUN_DIR

mkdir -p $AREX_DOCUMENT_ROOT/{old-location,new}
echo 'project old readme'    > $AREX_DOCUMENT_ROOT/old-location/README
echo 'project old index'     > $AREX_DOCUMENT_ROOT/old-location/index.html
echo 'project new readme'    > $AREX_DOCUMENT_ROOT/README
echo 'project new index'     > $AREX_DOCUMENT_ROOT/new/index.html
echo 'private project readme' > $AREX_DOCUMENT_ROOT/new/README

echo "[1] /old-location is rewritten to /new, except /old-loaction/README is rewritten to /README"
# just try to get new /new/index.html directly
curl -s http://localhost:$AREX_RUN_PORT1/new/                | grep 'project new index' || exit_code=1
# get new /new/index.html trough mod_lua rewrite
curl -s http://localhost:$AREX_RUN_PORT1/old-location/       | grep 'project new index' || exit_code=1
# get new /README trough mod_lua rewrite
curl -s http://localhost:$AREX_RUN_PORT1/old-location/README | grep 'project new readme' || exit_code=1

echo "[2] show the difference between early and late"
# mod_lua is called early, mod_alias won't get into play
curl -s http://localhost:$AREX_RUN_PORT2/old-location/README | grep 'project new readme' || exit_code=2
# mod_lua is called late, mod_alias will steal the rewrite
curl -s --location http://localhost:$AREX_RUN_PORT3/old-location/README | grep 'private project readme' || exit_code=2

echo "[3] error log contains mod_lua bits"
grep '\[lua:info\]' $AREX_RUN_DIR/error_log || exit_code=3

exit $exit_code
