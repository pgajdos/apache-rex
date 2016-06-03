exit_code=0

echo 'site index' > $AREX_DOCUMENT_ROOT/index.html
echo 'document' > $AREX_DOCUMENT_ROOT/document.html

curl -s http://localhost:$AREX_PORT/              \
        http://localhost:$AREX_PORT/document.html > /dev/null

mkdir -p $AREX_RUN_DIR/demultiplex
firehose -f $AREX_RUN_DIR/requests.firehose  --output-directory $AREX_RUN_DIR/demultiplex
firehose -f $AREX_RUN_DIR/responses.firehose --output-directory $AREX_RUN_DIR/demultiplex

echo "[1] there was only one connection and was logged into one *.response file and one *.request file"
ls -l $AREX_RUN_DIR/demultiplex/*.request | wc -l | grep 1 || exit_code=1
req_dump_filename="$AREX_RUN_DIR/demultiplex/*.request"
# $uuid.request ~ $uuid.response
res_dump_filename=$(echo $req_dump_filename | sed s:request$:response:)
(grep 'GET / ' $req_dump_filename && grep 'GET /document.html ' $req_dump_filename) || exit_code=1 
(grep 'site index' $res_dump_filename && grep 'document' $res_dump_filename) || exit_code=1

exit $exit_code
