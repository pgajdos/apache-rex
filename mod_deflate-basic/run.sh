exit_code=0

for i in $(seq 1 5); do echo 'content to be deflated'; done > $AREX_DOCUMENT_ROOT/index.html
file_size=$(wc -c < $AREX_DOCUMENT_ROOT/index.html)

echo "[1] DEFLATE outputfilter employed"
size_download=$(curl --silent -H "Accept-Encoding: gzip,deflate" --write-out '%{size_download}\n' http://localhost:$AREX_RUN_PORT/ --output /dev/null)
echo "file size: $file_size   download size: $size_download"
[ $size_download -lt $file_size ] || exit_code=1

echo "[2] DEFLATE output filter disabled (by not accepting gzip encoding)"
size_download=$(curl --silent --write-out '%{size_download}\n' http://localhost:$AREX_RUN_PORT/ --output /dev/null)
echo "file size: $file_size   download size: $size_download"
[ $size_download -eq $file_size ] || exit_code=2

echo "[3] employ INFLATE in virtual host as proxy to main server, which DEFLATEs data"
size_download=$(curl --silent -H "Accept-Encoding: gzip,deflate" --write-out '%{size_download}\n' http://localhost:$AREX_RUN_PORT1/ --output /dev/null)
echo "file size: $file_size   download size: $size_download"
[ $size_download -eq $file_size ] || exit_code=3

exit $exit_code
