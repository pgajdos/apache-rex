exit_code=0

msg='Today, there will be raining whole day.'
note='Otherwise the weather will be different.'
error='416 Requested Range Not Satisfiable'
echo $msg > $AREX_DOCUMENT_ROOT/weather-data.bufr
mkdir -p $AREX_DOCUMENT_ROOT/no-ranges/
echo "$note" > $AREX_DOCUMENT_ROOT/no-ranges/note.txt
mkdir -p $AREX_DOCUMENT_ROOT/no-unlimited-ranges/
echo "$msg $note" > $AREX_DOCUMENT_ROOT/no-unlimited-ranges/data.txt

echo "[1] get document in 10-byte chunks"
lbound=0
hbound=9
nbytes=$(echo $msg | wc -c)
nparts="$(($nbytes / 10))"
for i in $(seq 1 $nparts); do
  # mimicking curl -r
  curl -s -H "Range: bytes=$lbound-$hbound" http://localhost:$AREX_PORT/weather-data.bufr
  lbound=$(($lbound + 10))
  hbound=$(($hbound + 10))
done | grep "$msg" || exit_code=1

echo "[2] full document is returned when for MaxRanges none"
curl -s -r '5-15' http://localhost:$AREX_PORT/no-ranges/note.txt | grep "$note" || exit_code=2

echo "[3] the range not found as the document is shorter than lower bound"
curl -s -r '50-100' http://localhost:$AREX_PORT/weather-data.bufr | grep "$error" || exit_code=3

echo "[4] as demonstrated in [1] already, 16-<outofbounds> and 16- have the same result"
part=
curl -s -r '18-100' http://localhost:$AREX_PORT/weather-data.bufr | grep "${msg:18}" || exit_code=4
curl -s -r '18-'    http://localhost:$AREX_PORT/weather-data.bufr | grep "${msg:18}" || exit_code=4

echo "[5] interestingly, we get 416 even if MaxRanges none"
curl -s -r '50-100' http://localhost:$AREX_PORT/no-ranges/note.txt | grep "$error" || exit_code=5

echo "[6] use 'continue' feature of curl"
curl -s -o $AREX_RUN_DIR/weather-data.txt http://localhost:$AREX_PORT/weather-data.bufr
cat $AREX_RUN_DIR/weather-data.txt
echo 'Today, there will be snowing whole day.' >> $AREX_DOCUMENT_ROOT/weather-data.bufr
curl -v -C -  -o $AREX_RUN_DIR/weather-data.txt http://localhost:$AREX_PORT/weather-data.bufr 2>&1 | grep '^> Range:'
cat $AREX_RUN_DIR/weather-data.txt | grep 'snowing' || exit_code=6
# request repeated on unchanged file
curl -v -C -  -o $AREX_RUN_DIR/weather-data.txt http://localhost:$AREX_PORT/weather-data.bufr 2>&1 | grep "$error"

echo "[7] use 'continue' feature of wget"
cd $AREX_RUN_DIR
# ensure weather-data.bufr does not exist (essential for the test)
rm -f weather-data.bufr
wget -q http://localhost:$AREX_PORT/weather-data.bufr
cat weather-data.bufr
echo 'Today, there will be windy whole day.' >> $AREX_DOCUMENT_ROOT/weather-data.bufr
wget --debug -c http://localhost:$AREX_PORT/weather-data.bufr 2>&1 | grep '^Range:' || exit_code=7
cat weather-data.bufr | grep 'windy' || exit_code=7
wget --debug -c http://localhost:$AREX_PORT/weather-data.bufr 2>&1 | grep "$error"  || exit_code=7

echo "[8] forbid unlimited ranges"
# last ten chars
curl -s -r '-10' http://localhost:$AREX_PORT/no-unlimited-ranges/data.txt | grep 'ifferent.'     || exit_code=8
# unlimited forbidden
curl -s -r '10-'  http://localhost:$AREX_PORT/no-unlimited-ranges/data.txt | grep '403 Forbidden' || exit_code=8

exit $exit_code

