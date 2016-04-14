exit_code=0

for i in 1 2 3 4 5; do
  mkdir -p $AREX_RUN_DIR/host$i-htdocs
done

echo "[1] rewriting from old to new"
for n in one two three four five; do
  echo "$n page" > $AREX_RUN_DIR/host1-htdocs/$n.html
done
curl -s http://localhost:$AREX_RUN_PORT1/one.html   | grep 'two page'  || exit_code=1
curl -s http://localhost:$AREX_RUN_PORT1/two.html   | grep 'two page'  || exit_code=1
curl -s http://localhost:$AREX_RUN_PORT1/three.html | grep "http://localhost:$AREX_RUN_PORT1/four.html" || exit_code=1
curl -s http://localhost:$AREX_RUN_PORT1/four.html  | grep 'four page' || exit_code=1

echo "[2] resource moved to another server"
curl -s --location http://localhost:$AREX_RUN_PORT2/five.html | grep 'five page' || exit_code=2

echo "[3] from static to dynamic"
cgi_dir=$AREX_RUN_DIR/host3-htdocs/~quux/
mkdir -p $cgi_dir
cat << EOF > $cgi_dir/foo.cgi
#!/bin/bash
echo 'Content-type: text/html'
echo ''
echo 'hello from cgi'
EOF
chmod 755 $cgi_dir/foo.cgi
curl -s http://localhost:$AREX_RUN_PORT3/~quux/foo.html | grep 'hello from cgi' || exit_code=3

echo "[4] backward compatibility for file extension change"
echo 'hello from PHP' > $AREX_RUN_DIR/host4-htdocs/bar.php
mkdir -p $AREX_RUN_DIR/host4-htdocs/subdir/
echo 'hello from HTML' > $AREX_RUN_DIR/host4-htdocs/subdir/foo.html
echo 'hello from HTML' > $AREX_RUN_DIR/host4-htdocs/subdir/foo.php
curl -s http://localhost:$AREX_RUN_PORT4/bar.html | grep 'hello from PHP' || exit_code=4
curl -s http://localhost:$AREX_RUN_PORT4/subdir/foo.html | grep 'hello from HTML' || exit_code=4

echo "[5] search for pages in more than one directory"
mkdir -p $AREX_RUN_DIR/host5-htdocs/dir{1,2}
echo 'first'  > $AREX_RUN_DIR/host5-htdocs/dir1/first.html
echo 'second' > $AREX_RUN_DIR/host5-htdocs/dir2/second.html
echo 'third'  > $AREX_RUN_DIR/host5-htdocs/third.html
curl -s http://localhost:$AREX_RUN_PORT5/first.html  | grep 'first'  || exit_code=5
curl -s http://localhost:$AREX_RUN_PORT5/second.html | grep 'second' || exit_code=5
curl -s http://localhost:$AREX_RUN_PORT5/third.html  | grep 'third'  || exit_code=5

exit $exit_code
