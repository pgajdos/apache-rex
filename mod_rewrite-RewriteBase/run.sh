exit_code=0

echo "[1] RewriteBase appends dir base on the beginning of the relative path"
mkdir -p $AREX_RUN_DIR/mirror/subdir1/
echo 'bar SUBDIR1' > $AREX_RUN_DIR/mirror/subdir1/bar.html
curl -s http://localhost:$AREX_RUN_PORT/subdir1/foo | grep 'bar SUBDIR1' || exit_code=1

echo "[2] more rules, correct document is chosen"
mkdir -p $AREX_RUN_DIR/mirror/subdir2/subsubdir/
echo 'bar SUBSUBDIR' > $AREX_RUN_DIR/mirror/subdir2/subsubdir/bar.html
echo 'obsolete index of SUBSUBDIR' > $AREX_RUN_DIR/mirror/subdir2/subsubdir/index.html
echo 'welcome in SUBSUBDIR' > $AREX_RUN_DIR/mirror/subdir2/subsubdir/welcome.html
curl -s http://localhost:$AREX_RUN_PORT/subdir2/subsubdir/foo | grep 'bar SUBSUBDIR' || exit_code=2
curl -s http://localhost:$AREX_RUN_PORT/subdir2/subsubdir/index.html | grep 'welcome in SUBSUBDIR' || exit_code=2

echo "[3] RewriteBase is missing"
mkdir -p $AREX_RUN_DIR/mirror/subdir3/
echo 'bar SUBDIR3' > $AREX_RUN_DIR/mirror/subdir3/bar.html
curl -s http://localhost:$AREX_RUN_PORT/subdir3/foo | grep '404 Not Found' || exit_code=3

echo "[4] WordPress htaccess example"
mkdir -p $AREX_RUN_DIR/mirror/wp
echo 'wordpress index' > $AREX_RUN_DIR/mirror/wp/index.php
echo 'wordpress help' > $AREX_RUN_DIR/mirror/wp/help.php
curl -s http://localhost:$AREX_RUN_PORT/wordpress/index.phpa | grep 'wordpress index' || exit_code=4
curl -s http://localhost:$AREX_RUN_PORT/wordpress/notexisting.php | grep 'wordpress index' || exit_code=4

exit $exit_code

