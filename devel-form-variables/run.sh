exit_code=0

echo "[1] echo url encoded form variables"
curl -s -X POST -d 'home=Cosby&favorite+flavor=flies' http://localhost:$AREX_PORT/form-variables-echo \
 | grep '\[favorite flavor=flies\] \[home=Cosby\]' || exit_code=1

exit $exit_code
