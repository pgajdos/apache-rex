exit_code=0

echo "[1] URL-based sharding across multiple backends"
mkdir -p $AREX_RUN_DIR/htdocs-vh1/home/user1
echo "user1's website" > $AREX_RUN_DIR/htdocs-vh1/home/user1/index.html
mkdir -p $AREX_RUN_DIR/htdocs-vh2/home/user{2,3}
echo "user2's website" > $AREX_RUN_DIR/htdocs-vh2/home/user2/index.html
echo "user3's website" > $AREX_RUN_DIR/htdocs-vh2/home/user3/index.html
mkdir -p $AREX_RUN_DIR/htdocs-vh3
echo "new user"        > $AREX_RUN_DIR/htdocs-vh3/new-user.html
for i in 1 2 3; do
  curl -s --location http://localhost:$AREX_PORT/users/user$i | grep "user$i's website" || exit_code=1
done
curl -s --location http://localhost:$AREX_PORT/users/user4 | grep 'new user' || exit_code=1

# did not managed working version with -U
echo "[2] On-the-fly Content-generation"
mkdir -p $AREX_RUN_DIR/htdocs-vh4
cat << EOF > $AREX_RUN_DIR/htdocs-vh4/generate-page.cgi
#!/bin/bash
echo "new page \$REQUEST_URI" > $AREX_RUN_DIR/htdocs-vh4/\$REQUEST_URI
#
echo 'Content-type: text/html'
echo ''
echo "\$REQUEST_URI created"
EOF
chmod 755 $AREX_RUN_DIR/htdocs-vh4/generate-page.cgi
curl -s http://localhost:$AREX_PORT4/doc.html | grep '/doc.html created' || exit_code=2
sleep 2
curl -s http://localhost:$AREX_PORT4/doc.html | grep 'new page /doc.html'|| exit_code=2

echo "[3] structured userdirs"
mkdir -p $AREX_RUN_DIR/htdocs-vh5/l/larry/public_html/
echo "welcome to larry's website" > $AREX_RUN_DIR/htdocs-vh5/l/larry/public_html/welcome.html
curl -s http://localhost:$AREX_PORT5/~larry/welcome.html | grep "welcome to larry's website" || exit_code=3

echo "[4] redirecting anchors"
mkdir -p $AREX_RUN_DIR/htdocs-vh6
curl -s -i http://localhost:$AREX_PORT6/one.html \
  | grep 'Location: http://localhost:60086/two.html%23beginning' || exit_code=4
curl -s -i http://localhost:$AREX_PORT6/three.html \
  | grep 'Location: http://localhost:60086/four.html#beginning'  || exit_code=4

echo "[5] set environment variables based on URL parts"
echo '6 reached' > $AREX_RUN_DIR/htdocs-vh6/6.html
curl -s http://localhost:$AREX_PORT6/five.html \
  | grep '6 reached' || exit_code=5

exit $exit_code

