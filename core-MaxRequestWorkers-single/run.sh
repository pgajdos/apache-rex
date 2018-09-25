exit_code=0

cgi_dir=$AREX_RUN_DIR/cgi-bin
mkdir -p  $cgi_dir

echo "[1] only one worker, requests are processed successively"
cat << EOF > $cgi_dir/a-script.cgi
#!/bin/bash
echo 'Content-type: text/html'
echo ''
echo -n 'Sleeping for 2s ..'
sleep 2
echo ' wake up.'
EOF
chmod 755 $cgi_dir/a-script.cgi

# running two requests in parallel
curl -s http://localhost:$AREX_PORT/cgi-bin/a-script.cgi &
time -f '%e' -o $AREX_RUN_DIR/TIME curl -s http://localhost:$AREX_PORT/cgi-bin/a-script.cgi&
sleep 6

time=$(cat $AREX_RUN_DIR/TIME)
echo "Elapsed time (in seconds): $time "
time="$(echo $time | tr -d '.')"
[ 400 -lt $time ] || exit_code=1

exit $exit_code

