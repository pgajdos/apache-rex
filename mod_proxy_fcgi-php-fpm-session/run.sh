exit_code=0

. ../lib/php-fpm

# https://wiki.apache.org/httpd/PHP-FPM

echo '<?php print strtoupper("hello from php fcgi"); ?>' > $AREX_DOCUMENT_ROOT/welcome.php
cp read-vars.php $AREX_DOCUMENT_ROOT
cp write-vars.php $AREX_DOCUMENT_ROOT

start_fpm

echo "[1] *.php files are proxied to php-fpm daemon"
curl -s -v -b $AREX_RUN_DIR/cookies -v \
   http://localhost:$AREX_PORT/write-vars.php \
   http://localhost:$AREX_PORT/read-vars.php > $AREX_RUN_DIR/curl.log 2>&1
grep 'Added cookie' $AREX_RUN_DIR/curl.log || exit_code=1
grep 'Set-Cookie' $AREX_RUN_DIR/curl.log || exit_code=1
grep 'Re-using existing connection' $AREX_RUN_DIR/curl.log || exit_code=1
grep 'Cookie' $AREX_RUN_DIR/curl.log || exit_code=1
grep 'green.*cat'  $AREX_RUN_DIR/curl.log || exit_code=1

echo
stop_fpm

exit $exit_code
