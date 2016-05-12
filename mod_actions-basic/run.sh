exit_code=0
cgi_dir=$AREX_RUN_DIR/cgi/
mkdir -p $cgi_dir

echo "[1] show PATH_INFO and PATH_TRANSLATED variables"
mkdir -p $AREX_DOCUMENT_ROOT/doc
echo "document data" > $AREX_DOCUMENT_ROOT/doc/doc.html
cat << EOF > $cgi_dir/variables.cgi
#!/bin/bash
echo 'Content-type: text/plain'
echo ''
echo "PATH_INFO: \$PATH_INFO"
echo "PATH_TRANSLATED: \$PATH_TRANSLATED"
EOF
chmod 755 $cgi_dir/variables.cgi
curl -s http://localhost:$AREX_PORT/doc/doc.html > $AREX_RUN_DIR/out-variables.txt
grep 'PATH_INFO: /doc/doc.html' $AREX_RUN_DIR/out-variables.txt || exit_code=1
grep 'PATH_TRANSLATED: /.*htdocs/doc/doc.html' $AREX_RUN_DIR/out-variables.txt || exit_code=1

echo "[2] add custom handler via Action/AddHandler"
echo "document text" > $AREX_DOCUMENT_ROOT/doc/page.doc
cat << EOF > $cgi_dir/layout.cgi
#!/bin/bash
echo 'Content-type: text/html'
echo ''
echo 'header'
echo '-----------------------'
cat  \$PATH_TRANSLATED
echo '-----------------------'
echo 'footer'
EOF
chmod 755 $cgi_dir/layout.cgi
curl -s http://localhost:$AREX_PORT/doc/page.doc > $AREX_RUN_DIR/out-layout-page.txt
head -n 1 $AREX_RUN_DIR/out-layout-page.txt | grep header || exit_code=2
tail -n 1 $AREX_RUN_DIR/out-layout-page.txt | grep footer || exit_code=2

echo "[3] show usage of Action on virtual location ('virtual' keyword)"
cat << EOF > $cgi_dir/system-info.cgi
#!/bin/bash
echo 'Content-type: text/html'
echo ''
uname -a
EOF
chmod 755 $cgi_dir/system-info.cgi
curl -s http://localhost:$AREX_PORT/system-info | grep 'GNU/Linux' || exit_code=3

echo "[4] Action on virtual location without 'virtual' keyword gives 404"
cat << EOF > $cgi_dir/other-info.cgi
#!/bin/bash
echo 'Content-type: text/html'
echo ''
echo bleble
EOF
chmod 755 $cgi_dir/other-info.cgi
curl -s http://localhost:$AREX_PORT/other-info | grep '404 Not Found' || exit_code=4

echo "[5] demonstrate usage of Script on GET and PUT requests"
mkdir -p $AREX_DOCUMENT_ROOT/test-script
echo 'index content' > $AREX_DOCUMENT_ROOT/test-script/index.html
cat << EOF > $cgi_dir/script-get.cgi
#!/bin/bash
echo 'Content-type: text/html'
echo ''
echo GET method
EOF
chmod 755 $cgi_dir/script-get.cgi
cat << EOF > $cgi_dir/script-put.cgi
#!/bin/bash
echo 'Content-type: text/html'
echo ''
echo PUT method
EOF
chmod 755 $cgi_dir/script-put.cgi
curl -X PUT -s http://localhost:$AREX_PORT/test-script/ | grep 'PUT method' || exit_code=5
curl -X GET -s http://localhost:$AREX_PORT/test-script/ | grep 'index content' || exit_code=5
curl -X GET -s http://localhost:$AREX_PORT/test-script/index.html?hi | grep 'GET method' || exit_code=5

exit $exit_code

