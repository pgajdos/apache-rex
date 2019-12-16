exit_code=0

# https://httpd.apache.org/docs/2.4/mod/mod_negotiation.html

#
# document language
#
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
curl -s -H 'Accept-Language: de'       http://localhost:$AREX_PORT/welcome.html | grep 'willkommen' || exit_code=1
curl -s -H 'Accept-Language: cs'       http://localhost:$AREX_PORT/welcome.html | grep 'vítejte'    || exit_code=1
curl -s                                http://localhost:$AREX_PORT/welcome.html | grep 'welcome'    || exit_code=1

echo "[2] negotiate document language; using alternatives with q-values"
# fr does not exist
curl -s -H 'Accept-Language: fr,cs'                   http://localhost:$AREX_PORT/welcome.html | grep 'vítejte'    || exit_code=2
# qvalue is set to 1.0 for de
curl -s -H 'Accept-Language: fr,cs;q=0.8,de,en;q=0.5' http://localhost:$AREX_PORT/welcome.html | grep 'willkommen' || exit_code=2

#
# document format
#
cp apache_pb.*      $AREX_DOCUMENT_ROOT
mkdir -p $AREX_RUN_DIR/output/

cat << EOF > $AREX_DOCUMENT_ROOT/apache_pb.img.var
URI: apache_pb.img

URI: apache_pb.png
Content-type: image/png; qs=0.8

URI: apache_pb.jpeg
Content-type: image/jpeg; qs=0.5

URI: apache_pb.txt
Content-type: text/plain; qs=0.01
EOF

echo "[3] negotiate document format, using qs-values and q-values"
# png is chosen thanks to qs=0.8
curl -s                           http://localhost:$AREX_PORT/apache_pb.img --output $AREX_RUN_DIR/output/apache_pb.img.1
file $AREX_RUN_DIR/output/apache_pb.img.1 | grep 'PNG'  || exit_code=3
# set q=1.0 for text/plain, overrides qs
curl -s -H "Accept: text/plain"   http://localhost:$AREX_PORT/apache_pb.img \
                             | grep 'Powered by Apache' || exit_code=3
# q=0.7 is set, but qs=0.8 wins
curl -s -H "Accept: image/png;q=0.5,image/jpeg;q=0.7" http://localhost:$AREX_PORT/apache_pb.img \
  --output $AREX_RUN_DIR/output/apache_pb.img.2
file $AREX_RUN_DIR/output/apache_pb.img.2 | grep 'PNG'  || exit_code=3
# q=0.9 is set, this wins
curl -s -H "Accept: image/png;q=0.5,image/jpeg;q=0.9" http://localhost:$AREX_PORT/apache_pb.img \
  --output $AREX_RUN_DIR/output/apache_pb.img.3
file $AREX_RUN_DIR/output/apache_pb.img.3 | grep 'JPEG' || exit_code=3


exit $exit_code
