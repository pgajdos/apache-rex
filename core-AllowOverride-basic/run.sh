exit_code=0

mkdir -p $AREX_DOCUMENT_ROOT/{foo,bar}
echo 'A.TXT' > $AREX_DOCUMENT_ROOT/foo/a.txt
ln -s $AREX_DOCUMENT_ROOT/foo/{a.txt,a_link.txt}
echo 'B.TXT' > $AREX_DOCUMENT_ROOT/bar/b.txt
ln -s $AREX_DOCUMENT_ROOT/bar/{b.txt,b_link.txt}
echo "Options FollowSymlinks" > $AREX_DOCUMENT_ROOT/foo/.htaccess
echo "Options FollowSymlinks" > $AREX_DOCUMENT_ROOT/bar/.htaccess

echo "[1] AllowOverride none"
curl -s http://localhost:$AREX_PORT/foo/a_link.txt | grep '403 Forbidden' || exit_code=1
echo "[2] AllowOverride all"
curl -s http://localhost:$AREX_PORT/bar/b_link.txt | grep 'B.TXT' || exit_code=2

exit $exit_code
