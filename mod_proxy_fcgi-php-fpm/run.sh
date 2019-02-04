exit_code=0

. ../lib/php-fpm

# https://wiki.apache.org/httpd/PHP-FPM

echo '<?php print strtoupper("hello from php fcgi"); ?>' > $AREX_DOCUMENT_ROOT/welcome.php

start_fpm

echo "[1] *.php files are proxied to php-fpm daemon"
curl -s http://localhost:$AREX_PORT/welcome.php | grep 'HELLO FROM PHP FCGI' || exit_code=1

echo
stop_fpm

exit $exit_code
