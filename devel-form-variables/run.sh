exit_code=0

echo "[1] echo url encoded form variables"
curl -s -X POST -d 'home=Cosby&favorite+flavor=flies' http://localhost:$AREX_PORT/form-variables-echo \
 | grep '\[favorite flavor=flies\] \[home=Cosby\]' || exit_code=1
# > $AREX_RUN_DIR/out

#grep 'Read: 34 bytes'                     $AREX_RUN_DIR/out || exit_code=1
#grep 'This is content of a request body.' $AREX_RUN_DIR/out || exit_code=1

exit $exit_code
