exit_code=0

mkdir -p $AREX_DOCUMENT_ROOT/foo
echo "A.TXT" > $AREX_DOCUMENT_ROOT/a.txt
echo "B.TXT" > $AREX_DOCUMENT_ROOT/foo/b.txt
ln -s ../a.txt $AREX_DOCUMENT_ROOT/foo/a_link.txt
ln -s foo/b.txt $AREX_DOCUMENT_ROOT/b_link.txt
echo 'C.TXT' > $AREX_DOCUMENT_ROOT/bar/c.txt

echo "[1] FollowSymlinks not set"
curl -s http://localhost:$AREX_PORT/b_link.txt | grep '403 Forbidden' || exit_code=1
echo "[2] FollowSymlinks set"
curl -s http://localhost:$AREX_PORT/foo/a_link.txt | grep 'A.TXT' || exit_code=2
echo "[3] Indexes not set"
curl -s http://localhost:$AREX_PORT/ | grep '403 Forbidden' || exit_code=3
echo "[4] Indexes set"
curl -s http://localhost:$AREX_PORT/foo/ | grep 'Index of /foo' || exit_code=4
echo "[5] Multiviews set"
curl -s http://localhost:$AREX_PORT/bar/c

exit $exit_code
