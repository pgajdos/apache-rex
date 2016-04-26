exit_code=0

echo "[1] for a directory allow access only from 127.0.0.1"

cp hooks.lua $AREX_RUN_DIR
mkdir -p $AREX_DOCUMENT_ROOT/admin
echo 'welcome' > $AREX_DOCUMENT_ROOT/index.html
echo 'welcome administrator' > $AREX_DOCUMENT_ROOT/admin/index.html

curl -s http://127.0.0.1:$AREX_RUN_PORT/        | grep '^welcome$' || exit_code=1
curl -s http://[::1]:$AREX_RUN_PORT/            | grep '^welcome$' || exit_code=1
curl -s http://127.0.0.1:$AREX_RUN_PORT/admin/  | grep 'welcome administrator' || exit_code=1
curl -s http://[::1]:$AREX_RUN_PORT/admin/      | grep '403' || exit_code=1

exit $exit_code
