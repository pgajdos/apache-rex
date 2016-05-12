exit_code=0

echo "[1] custom output filter (added by AddOutputFilter) rewrites html document content"
echo 'this is a sample text' > $AREX_DOCUMENT_ROOT/index.html
curl -s http://localhost:$AREX_PORT/ | grep 'this is a SAMPLE text' || exit_code=1

echo "[2] html document is unchanged because custom filter was removed (by RemoveOutputFilter)"
mkdir -p $AREX_DOCUMENT_ROOT/foo/
echo 'this is a sample text' > $AREX_DOCUMENT_ROOT/foo/index.html
curl -s http://localhost:$AREX_PORT/foo/ | grep 'this is a sample text' || exit_code=2

echo "[3] custom input filter (added by AddInputFilter) rewrites POST data"
mkdir -p $AREX_DOCUMENT_ROOT/cgi/
cat << EOF > $AREX_DOCUMENT_ROOT/cgi/echo-post-data.cgi
#!/bin/bash
echo "Content-type: text/html"
echo ""
read -n \$CONTENT_LENGTH data; echo \$data
EOF
chmod 755 $AREX_DOCUMENT_ROOT/cgi/echo-post-data.cgi
curl -s -X POST -d 'this is a sample text' http://localhost:$AREX_PORT/cgi/echo-post-data.cgi | grep 'this is a SAMPLE text' || exit_code=3

echo "[4] POST data is unchanged -- custom filter was removed by RemoveOutputFilter"
mkdir -p $AREX_DOCUMENT_ROOT/cgi/foo/
cat << EOF > $AREX_DOCUMENT_ROOT/cgi/foo/echo-post-data.cgi
#!/bin/bash
echo "Content-type: text/html"
echo ""
read -n \$CONTENT_LENGTH data; echo \$data
EOF
chmod 755 $AREX_DOCUMENT_ROOT/cgi/foo/echo-post-data.cgi
curl -s -X POST -d 'this is a sample text' http://localhost:$AREX_PORT/cgi/foo/echo-post-data.cgi | grep 'this is a sample text' || exit_code=4

exit $exit_code
