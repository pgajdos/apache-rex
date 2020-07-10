exit_code=0

# https://cwiki.apache.org/confluence/display/HTTPD/PHP-FPM

echo '<?php print strtoupper("hello from php fcgi"); ?>' > $AREX_DOCUMENT_ROOT/welcome.php

echo "[1] *.php files are proxied to php-fpm daemon"
curl -s http://localhost:$AREX_PORT/welcome.php | grep 'HELLO FROM PHP FCGI' || exit_code=1

exit $exit_code
