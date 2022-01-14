exit_code=0

htpasswd -bc $AREX_RUN_DIR/htpasswd john StrongPassword
echo 'Test SSL via Proxy' > $AREX_DOCUMENT_ROOT/index.html

echo "[1] with Expect: 100-continue"
# note, curl adds Expect: 100-continue automatically for POST request with over 1024
curl -v -s -H 'Expect: 100-continue' --cacert $AREX_RUN_DIR/ca/my.crt --resolve "frontend.su.se:$AREX_PORT1:127.0.0.1" https://frontend.su.se:$AREX_PORT1/ \
     --next --cacert $AREX_RUN_DIR/ca/my.crt --resolve "frontend.su.se:$AREX_PORT1:127.0.0.1" -u john:StrongPassword https://frontend.su.se:$AREX_PORT1/ \
     2>&1 | grep -i connection
# do not test anything so far

echo "[2] without Expect: 100-continue"
curl -v -s --cacert $AREX_RUN_DIR/ca/my.crt --resolve "frontend.su.se:$AREX_PORT1:127.0.0.1" https://frontend.su.se:$AREX_PORT1/ \
     --next --cacert $AREX_RUN_DIR/ca/my.crt --resolve "frontend.su.se:$AREX_PORT1:127.0.0.1" -u john:StrongPassword https://frontend.su.se:$AREX_PORT1/ \
     2>&1 | grep -i connection
# do not test anything sofar 

exit $exit_code
