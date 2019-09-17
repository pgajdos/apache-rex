exit_code=0

. ../lib/processman

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

child_pid=$(a_child_pid)
echo "Make request, but there is only child $child_pid; request takes long"
curl -s http://localhost:$AREX_PORT/cgi-bin/long.cgi&
sleep 1

echo "Killing child pid $child_pid"
kill -SEGV $child_pid
sleep 1

child_pid=$(a_child_pid)
echo "Make a request again with another child (pid $child_pid)"
curl -s http://localhost:$AREX_PORT/cgi-bin/long.cgi&
sleep 1

echo "Killing child pid $child_pid with another signal"
kill -BUS $child_pid
sleep 1

echo "[1] error_log contains backtrace for AH00051"
grep ap_process_child_status $AREX_RUN_DIR/error_log || exit_code=1

echo
echo "[2] wku_log contains data of the crash"
echo "The report contains:"
echo "===================="
# highlights in the report
echo "(a) Crash happened, when"
echo "------------------------"
grep '**** Crash at'          $AREX_RUN_DIR/wku_log | tee $AREX_RUN_DIR/wku_log-excerpt
wc -l $AREX_RUN_DIR/wku_log-excerpt | grep -q '^2 ' || exit_code=2
echo "(b) What uncaught signal caused it"
echo "----------------------------------"
grep 'Fatal signal:'          $AREX_RUN_DIR/wku_log | tee $AREX_RUN_DIR/wku_log-excerpt
wc -l $AREX_RUN_DIR/wku_log-excerpt | grep -q '^2 ' || exit_code=2
echo "(c) Backtrace, where the crash happened"
echo "---------------------------------------"
grep 'mod_cgi.so'             $AREX_RUN_DIR/wku_log | tee $AREX_RUN_DIR/wku_log-excerpt
wc -l $AREX_RUN_DIR/wku_log-excerpt | grep -q '^4 ' || exit_code=2
echo "(d) Request line processed"
echo "--------------------------"
grep -A 1 'Request line'      $AREX_RUN_DIR/wku_log | tee $AREX_RUN_DIR/wku_log-excerpt
wc -l $AREX_RUN_DIR/wku_log-excerpt | grep -q '^5 ' || exit_code=2
echo "(e) Client connection processed"
echo "-------------------------------"
grep -A 1 'Client connection' $AREX_RUN_DIR/wku_log | tee $AREX_RUN_DIR/wku_log-excerpt
wc -l $AREX_RUN_DIR/wku_log-excerpt | grep -q '^5 ' || exit_code=2

echo
echo See $AREX_RUN_DIR/wku_log for details.

exit $exit_code
