exit_code=0

for i in 1 2 3 4; do
  mkdir -p $AREX_RUN_DIR/customers/$i/cgi-bin
  echo "documentation for customer $i" > $AREX_RUN_DIR/customers/$i/doc.html
  echo "#!/bin/bash"                       > $AREX_RUN_DIR/customers/$i/cgi-bin/script.cgi
  echo "echo 'Content-type: text/html'"    >> $AREX_RUN_DIR/customers/$i/cgi-bin/script.cgi
  echo "echo ''"                           >> $AREX_RUN_DIR/customers/$i/cgi-bin/script.cgi  
  echo "echo 'cgi script for customer $i'" >> $AREX_RUN_DIR/customers/$i/cgi-bin/script.cgi
  chmod 755 $AREX_RUN_DIR/customers/$i/cgi-bin/script.cgi
done
mkdir -p $AREX_RUN_DIR/icons/
echo 'back icon' > $AREX_RUN_DIR/icons/back.png

echo "[1] picked correct document"
curl -s --resolve customer-1.example.com:$AREX_PORT:127.0.0.1 http://customer-1.example.com:$AREX_PORT/doc.html \
 | grep 'documentation for customer 1' || exit_code=1

echo "[2] picked correct document, employ tolower"
curl -s --resolve custoMer-4.example.com:$AREX_PORT:127.0.0.1 http://custoMer-4.example.com:$AREX_PORT/doc.html \
 | grep 'documentation for customer 4' || exit_code=2

echo "[3] picked icon from common dir"
curl -s --resolve customer-3.example.com:$AREX_PORT:127.0.0.1 http://customer-3.example.com:$AREX_PORT/icons/back.png \
 | grep 'back icon' || exit_code=3

echo "[4] picked correct cgi script"
curl -s --resolve customer-2.example.com:$AREX_PORT:127.0.0.1 http://customer-2.example.com:$AREX_PORT/cgi-bin/script.cgi \
 | grep 'cgi script for customer 2' || exit_code=4

echo "[5] picked correct cgi script, employ tolower"
curl -s --resolve customer-3.EXAMPLE.com:$AREX_PORT:127.0.0.1 http://customer-3.EXAMPLE.com:$AREX_PORT/cgi-bin/script.cgi \
 | grep 'cgi script for customer 3' || exit_code=5

exit $exit_code

