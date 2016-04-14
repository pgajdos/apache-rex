exit_code=0

# https://httpd.apache.org/docs/2.4/mod/mod_negotiation.html

echo 'welcome'    > $AREX_DOCUMENT_ROOT/welcome.html.en
echo 'vítejte'    > $AREX_DOCUMENT_ROOT/welcome.html.cs
echo 'willkommen' > $AREX_DOCUMENT_ROOT/welcome.html.de

cat << EOF > $AREX_DOCUMENT_ROOT/welcome.html.var
URI: welcome.html

Content-language: de
Content-type: text/html
URI: welcome.html.de

Content-language: en
Content-type: text/html
URI: welcome.html.en

Content-language: cs
Content-type: text/html
URI: welcome.html.cs
EOF

echo "[1] negotiate document language"
curl -s -H 'Accept-Language: de' http://localhost:$AREX_RUN_PORT/welcome.html | grep 'willkommen' || exit_code=1
curl -s -H 'Accept-Language: cs' http://localhost:$AREX_RUN_PORT/welcome.html | grep 'vítejte'    || exit_code=1
curl -s                          http://localhost:$AREX_RUN_PORT/welcome.html | grep 'welcome'    || exit_code=1

exit $exit_code
