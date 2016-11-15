exit_code=0

cp example_handler.lua $AREX_DOCUMENT_ROOT

echo "[1] send chunked request and echo it"
# non chunked request
(echo "POST /example_handler.lua HTTP/1.1"; 
 echo "Host: localhost:60080"; 
 echo "Content-Length: 30"; 
 echo "Content-Type: application/x-www-form-urlencoded"; 
 echo; echo "user=vochomurka&action=povidla"; 
 echo; 
 sleep 2;) | telnet localhost 60080 > $AREX_RUN_DIR/resp1
# chunked request
(echo "POST /example_handler.lua HTTP/1.1"; 
 echo "Host: localhost:60080"; 
 echo "Transfer-Encoding: chunked"; 
 echo "Content-Type: application/x-www-form-urlencoded"; 
 echo; 
 echo "e"; 
 echo "user=kremilek&"; 
 echo "e"; 
 echo "action=kukacka"; 
 echo "0"; 
 echo; 
 sleep 2;) | telnet localhost 60080 > $AREX_RUN_DIR/resp2
grep 'user: vochomurka' $AREX_RUN_DIR/resp1 || exit_code=1
grep 'action: povidla'  $AREX_RUN_DIR/resp1 || exit_code=1
grep 'user: kremilek' $AREX_RUN_DIR/resp2 || exit_code=1
grep 'action: kukacka'  $AREX_RUN_DIR/resp2 || exit_code=1
exit $exit_code
