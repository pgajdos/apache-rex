exit_code=0

echo index >  $AREX_DOCUMENT_ROOT/index.html

echo "[1] forensic log contains begin and end of processing request"
curl -s http://localhost:$AREX_PORT/ 
head -n 1 $AREX_RUN_DIR/forensic_log | grep '+.*|GET.*|User-Agent:curl' || exit_code=1
request_id=$(head -n 1 $AREX_RUN_DIR/forensic_log | sed 's:+\(.*\)|GET.*:\1:')
grep "\-$request_id" $AREX_RUN_DIR/forensic_log || exit_code=1

echo
echo "[2] forensic log contains also specified header"
curl -s -X POST -H 'my-header: hello_world' http://localhost:$AREX_PORT/
grep '+.*|POST.*|my-header:hello_world' $AREX_RUN_DIR/forensic_log || exit_code=2

echo
echo "[3] after apache child pid kill, there will be no pairwise line"
main_process_pid=$(cat $AREX_RUN_DIR/pid)
child_pid=$(ps -A | grep httpd | grep -v "$main_process_pid" | sed 's:^\s*\([0-9]*\).*:\1:')
cgi_dir=$AREX_RUN_DIR/cgi-bin
mkdir -p  $cgi_dir
cat << EOF > $cgi_dir/long.cgi
#!/bin/bash
echo 'Content-type: text/html'
echo ''
sleep 5
echo 'result'
EOF
chmod 755 $cgi_dir/long.cgi

echo "Make request, but there is only child $child_pid and request takes long"
curl -s http://localhost:$AREX_PORT/cgi-bin/long.cgi&
sleep 1

echo "Killing child pid $child_pid"
kill -9 $child_pid

echo "forensic_log contains only + line, but not the - line"
grep 'long.cgi' $AREX_RUN_DIR/forensic_log | grep long.cgi | tee $AREX_RUN_DIR/forensic_log-excerpt
nlines=$(cat $AREX_RUN_DIR/forensic_log-excerpt | wc -l)
[ "$nlines" -eq 1 ] || exit_code=3

echo "Alternatively, via check_forensic script"
check_forensic $AREX_RUN_DIR/forensic_log | tee $AREX_RUN_DIR/check_forensic-output
diff $AREX_RUN_DIR/{forensic_log-excerpt,check_forensic-output} || exit_code=3

exit $exit_code

