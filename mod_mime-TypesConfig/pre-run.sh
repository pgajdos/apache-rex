cat << EOF > $AREX_RUN_DIR/mime.types
bar/tst         tst
# application/xml is shadowed by text/xml for xml
application/xml xml
text/xml        xml
# text/xml is shadowed by application/xml for xml2
text/xml        xml2
application/xml xml2
# my-text/txt will be shadowed by your-text/doc (by AddType)
my-text/txt     txt
EOF

