exit_code=0

mkdir -p $AREX_RUN_DIR/htdocs-vh1
echo 'Virtual Host 1' > $AREX_RUN_DIR/htdocs-vh1/index.html
mkdir -p $AREX_RUN_DIR/htdocs-vh2
echo 'Virtual Host 2' > $AREX_RUN_DIR/htdocs-vh2/index.html

curl -s http://localhost:$AREX_PORT/vh1/ > /dev/null
curl -s http://localhost:$AREX_PORT/vh2/ > /dev/null

mkdir -p $AREX_RUN_DIR/demultiplex
firehose -f $AREX_RUN_DIR/requests.firehose --output-directory $AREX_RUN_DIR/demultiplex
firehose -f $AREX_RUN_DIR/responses.firehose --output-directory $AREX_RUN_DIR/demultiplex

# dunno why they are *re{sponse,quest}.part
echo "[1] proxied requests and reqsponses are recorded"
ls $AREX_RUN_DIR/demultiplex
cat $AREX_RUN_DIR/demultiplex/*response* | grep 'Virtual Host' || exit_code=1
cat $AREX_RUN_DIR/demultiplex/*request*  | grep '^Host: localhost:6008' || exit_code=1
cat $AREX_RUN_DIR/demultiplex/*request*  | grep '^X-Forwarded-Host: localhost:60080' || exit_code=1

exit $exit_code
