exit_code=0
cgi_dir=$AREX_RUN_DIR/cgi/
mkdir -p $cgi_dir

echo "[1] registred extension for application/x-httpd-cgi"
cat << EOF > $cgi_dir/script.my-cgi
#!/bin/bash
echo "Content-type: text/html"
echo ''
echo 'CGI Bash Example'
EOF
chmod 755 $cgi_dir/script.my-cgi
curl -s http://localhost:$AREX_RUN_PORT/cgi/script.my-cgi | grep 'CGI Bash Example' || exit_code=1
curl -s http://localhost:$AREX_RUN_PORT/cgi/script.my-cgi | grep 'Content-type: text/html' && exit_code=1

echo "[2] non-registered extension for application/x-httpd-cgi"
cat << EOF > $cgi_dir/script.my-txt
#!/bin/bash
echo "Content-type: text/html"
echo ''
echo 'CGI Bash Example'
EOF
chmod 755 $cgi_dir/script.my-txt
curl -s http://localhost:$AREX_RUN_PORT/cgi/script.my-txt | grep 'Content-type: text/html' || exit_code=2

echo "[3] registered extension for cgi-script handler"
cat << EOF > $cgi_dir/script.my-cgicgi
#!/bin/bash
echo "Content-type: text/html"
echo ''
echo 'CGI Bash Example'
EOF
chmod 755 $cgi_dir/script.my-cgicgi
curl -s http://localhost:$AREX_RUN_PORT/cgi/script.my-cgicgi | grep 'CGI Bash Example' || exit_code=3
curl -s http://localhost:$AREX_RUN_PORT/cgi/script.my-cgicgi | grep 'Content-type: text/html' && exit_code=3

echo "[4] AddOutputFilter CaseFilter"
echo "Test CaseFilter" > $AREX_DOCUMENT_ROOT/document.html
curl -s http://localhost:$AREX_RUN_PORT/document.html | grep 'TEST CASEFILTER' || exit_code=4

echo "[5] add custom handler via Action/AddHandler"
echo "document text" > $AREX_DOCUMENT_ROOT/page.doc
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
curl -s http://localhost:$AREX_RUN_PORT/page.doc > $AREX_RUN_DIR/run-out.txt
grep 'footer'        $AREX_RUN_DIR/run-out.txt || exit_code=5
grep 'document text' $AREX_RUN_DIR/run-out.txt || exit_code=5

exit $exit_code

