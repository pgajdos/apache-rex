mkdir -p $AREX_RUN_DIR/demultiplex
mkfifo $AREX_RUN_DIR/pipe.firehose
cat $AREX_RUN_DIR/pipe.firehose | firehose --output-directory $AREX_RUN_DIR/demultiplex &
