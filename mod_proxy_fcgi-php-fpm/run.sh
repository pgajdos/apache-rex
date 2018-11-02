exit_code=0

. ../lib/processman

# https://wiki.apache.org/httpd/PHP-FPM

echo '<?php print strtoupper("hello from php"); ?>' > $AREX_DOCUMENT_ROOT/welcome.php

# start php-fpm server
echo -n 'Starting php-fpm .. '
cat << EOF > $AREX_RUN_DIR/php-fpm.conf
[global]
pid       = $AREX_RUN_DIR/php-fpm.pid
error_log = $AREX_RUN_DIR/php-fpm.log

[www]
listen   = 127.0.0.1:$AREX_FCGI_PORT
pm                   = dynamic
pm.max_children      = 5
pm.start_servers     = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 3
EOF
php-fpm --fpm-config $AREX_RUN_DIR/php-fpm.conf
sleep 1
echo $(cat $AREX_RUN_DIR/php-fpm.pid)
echo

echo "[1] *.php files are proxied to php-fpm daemon"
curl -s http://localhost:$AREX_PORT/welcome.php | grep 'HELLO FROM PHP' || exit_code=1

# stop php-fpm server
echo
echo -n 'Stopping php-fpm ... '
kill_pid_port $(cat $AREX_RUN_DIR/php-fpm.pid) $AREX_FCGI_PORT && echo 'done.' || echo 'FAILED.'

exit $exit_code
