exit_code=0

# 2017-04-28 09:55
A_DATE=1704280955

echo "Test document." > $AREX_DOCUMENT_ROOT/test.txt
size=$(printf "%x" $(stat -c "%s" $AREX_DOCUMENT_ROOT/test.txt))
touch -mt $A_DATE $AREX_DOCUMENT_ROOT/test.txt
mtime=$(printf %x $(printf "%-16s" $(stat -c "%Y" $AREX_DOCUMENT_ROOT/test.txt) | sed 's: :0:g'))

for subdir in {default,all/{,-inode},inode,mtime,size}; do
  mkdir $AREX_DOCUMENT_ROOT/$subdir
  cp $AREX_DOCUMENT_ROOT/test.txt $AREX_DOCUMENT_ROOT/$subdir/
  touch -mt 1704280955 $AREX_DOCUMENT_ROOT/$subdir/test.txt
done

function get_etag()
{
  uri_dir=$1
  etag_header=$(curl -v http://localhost:$AREX_PORT/$uri_dir/test.txt 2>&1 | grep ETag)
  echo $etag_header | sed 's@.*ETag: "\([0-9a-f\-]\+\)".*@\1@'
}

echo "[1] default ETag form, should be size and mtime (see CVE-2003-1418)"
etag=$(get_etag default)
[ "$etag" == "$size-$mtime" ] || exit_code=1
echo $etag

echo "[2] All, size, mtime and inode"
etag=$(get_etag all)
inode=$(printf "%x" $(stat -c "%i" $AREX_DOCUMENT_ROOT/all/test.txt))
[ "$etag" == "$inode-$size-$mtime" ] || exit_code=2
echo $etag

echo "[3] in subdir, 'All' is inherited, but selected -INode"
etag=$(get_etag all/-inode)
[ "$etag" == "$size-$mtime" ] || exit_code=3
echo $etag

echo "[4] INode only"
etag=$(get_etag inode)
inode=$(printf "%x" $(stat -c "%i" $AREX_DOCUMENT_ROOT/inode/test.txt))
[ "$etag" == "$inode" ] || exit_code=4
echo $etag

echo "[5] MTime only"
etag=$(get_etag mtime)
[ "$etag" == "$mtime" ] || exit_code=5
echo $etag

echo "[6] Size only"
etag=$(get_etag size)
[ "$etag" == "$size" ] || exit_code=6

exit $exit_code
