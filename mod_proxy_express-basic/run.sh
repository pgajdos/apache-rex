exit_code=0

# http://httpd.apache.org/docs/2.4/mod/mod_proxy_express.html#proxyexpressdbmfile

# create Host: header -> backend map
cat << EOF > $AREX_RUN_DIR/express-map.txt
##
##express-map.txt:
##

www1.example.com http://localhost:$AREX_PORT1
www2.example.com http://localhost:$AREX_PORT2
www3.example.com http://localhost:$AREX_PORT3
EOF
httxt2dbm -f sdbm -i $AREX_RUN_DIR/express-map.txt -o $AREX_RUN_DIR/emap.db

for i in 1 2 3; do
  mkdir -p $AREX_RUN_DIR/htdocs-vh$i
  echo "backend $i" > $AREX_RUN_DIR/htdocs-vh$i/index.html
done

echo "[1] backend is chosen via Host header"
for i in 1 2 3; do
  curl -s -H "Host: www$i.example.com" http://localhost:$AREX_PORT/ | grep "backend $i" || exit_code=1
done

exit $exit_code
