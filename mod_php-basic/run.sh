exit_code=0

echo '<?php print strtoupper("hello from php module"); ?>' > $AREX_DOCUMENT_ROOT/welcome.php

echo "[1] php code is run"
curl -s http://localhost:$AREX_PORT/welcome.php | grep 'HELLO FROM PHP MODULE' || exit_code=1

exit $exit_code
