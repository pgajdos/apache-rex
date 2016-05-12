exit_code=0

echo "[1] two harnesses with three filter providers"
cat << EOF > $AREX_DOCUMENT_ROOT/document.shtml
<!--#if expr="%{SERVER_SOFTWARE} =~ /linux/i" -->
Have a lot of fun!
<!--#endif -->
EOF
cat << EOF > $AREX_DOCUMENT_ROOT/document.txt
If you are on linux: Have a lot of fun!
EOF
curl -s http://localhost:$AREX_PORT/document.shtml | grep 'Have a lot of FUN!' || exit_code=1
curl -s http://localhost:$AREX_PORT/document.txt | grep 'If you are on LINUX: Have a lot of FUN!' || exit_code=1

exit $exit_code

