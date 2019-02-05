. ../lib/php-fpm
exit_code=0

htpasswd -bc $AREX_RUN_DIR/htpasswd john StrongPassword
echo '<?php print "Hey $_SERVER['REMOTE_USER']! Your password has leaked: $_SERVER['PHP_AUTH_PW']\n";  ?>' \
  > $AREX_DOCUMENT_ROOT/welcome.php

start_fpm

echo "[1] credentials are passed to php script"
curl -s -u john:StrongPassword http://localhost:$AREX_PORT1/welcome.php \
  | grep 'Hey john! Your password has leaked: StrongPassword' || exit_code=1

echo "[2] credentials are not passed to php script"
curl -s -u john:StrongPassword http://localhost:$AREX_PORT2/welcome.php \
  | grep 'Hey john! Your password has leaked: $' || exit_code=2

echo
stop_fpm

exit $exit_code
