exit_code=0

msg='Today, there will be raining whole day.'
note='Otherwise the weather will be different.'
error='416 Requested Range Not Satisfiable'
echo $msg > $AREX_DOCUMENT_ROOT/weather-data.bufr
mkdir -p $AREX_DOCUMENT_ROOT/no-ranges/
echo "$note" > $AREX_DOCUMENT_ROOT/no-ranges/note.txt

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
echo 'Hurray!' >> $AREX_DOCUMENT_ROOT/weather-data.bufr
curl -s -C -  -o $AREX_RUN_DIR/weather-data.txt http://localhost:$AREX_PORT/weather-data.bufr
cat $AREX_RUN_DIR/weather-data.txt | grep 'Hurray!' || exit_code=6

exit $exit_code

