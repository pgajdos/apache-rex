exit_code=0

echo "[1] ssi expanded for document with certain extension"
cat << EOF > $AREX_DOCUMENT_ROOT/ssi-by-extension.shtml
<!--#if expr="%{SERVER_SOFTWARE} =~ /linux/i" -->
Have a lot of fun!
<!--#endif -->
EOF
curl -s http://localhost:$AREX_RUN_PORT/ssi-by-extension.shtml | grep -v '^$' | tee 1.txt
grep -q 'Have a lot of fun!' 1.txt || exit_code=1
grep -q 'SERVER_SOFTWARE'    1.txt && exit_code=1

echo "[2] ssi expanded trouch for document with executable bit set"
cat << EOF > $AREX_DOCUMENT_ROOT/ssi-by-xbit.html
<!--#if expr="%{SERVER_SOFTWARE} =~ /linux/i" -->
Have a lot of fun!
<!--#endif -->
EOF
chmod 755 $AREX_DOCUMENT_ROOT/ssi-by-xbit.html
curl -s http://localhost:$AREX_RUN_PORT/ssi-by-xbit.html | grep -v '^$' | tee 2.txt
grep -q 'Have a lot of fun!' 2.txt || exit_code=2
grep -q 'SERVER_SOFTWARE'    2.txt && exit_code=2

echo "[3] ssi not expended for not registered extension and without xbit"
cat << EOF > $AREX_DOCUMENT_ROOT/nossi.html
<!--#if expr="%{SERVER_SOFTWARE} =~ /linux/i" -->
Have a lot of fun!
<!--#endif -->
EOF
curl -s http://localhost:$AREX_RUN_PORT/nossi.html | tee 3.txt
grep -q 'SERVER_SOFTWARE'    3.txt || exit_code=3

echo "[4] ssi together with cgi module (exec directive)"
cat << EOF > $AREX_DOCUMENT_ROOT/ssi-cgi.shtml
Current dir content:
<!--#exec cmd="ls" -->
EOF
curl -s http://localhost:$AREX_RUN_PORT/ssi-cgi.shtml | tee 4.txt
grep -q 'ssi-cgi.shtml' 4.txt || exit_code=4

exit $exit_code

