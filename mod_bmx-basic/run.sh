exit_code=0

mkdir -p $AREX_DOCUMENT_ROOT-virtualhost
echo 'This is a virtual host.' > $AREX_DOCUMENT_ROOT-virtualhost/index.html

nrequests_vh=10
for i in `seq 1 $nrequests_vh`; do
  curl -s http://localhost:$AREX_PORT1/ > /dev/null
done
curl -s http://localhost:$AREX_PORT/no.html > $AREX_RUN_DIR/404-response.txt
curl -s http://localhost:$AREX_PORT1/no.html > /dev/null

curl -s http://localhost:$AREX_PORT/bmx > $AREX_RUN_DIR/bmx.out

echo "[1] show basic information"
grep 'ServerName'    $AREX_RUN_DIR/bmx.out || exit_code=1
grep 'ServerVersion' $AREX_RUN_DIR/bmx.out || exit_code=1

echo "[2] show virtualhost statistics"
nchars_200=$(wc -c $AREX_DOCUMENT_ROOT-virtualhost/index.html | sed 's;^\([0-9]\+\).*;\1;')
nchars_404=$(wc -c $AREX_RUN_DIR/404-response.txt | sed 's;^\([0-9]\+\).*;\1;')
echo -----
echo Host=_GLOBAL_ gets ALL requests
grep "^InRequestsGET: $((nrequests_vh+2))$" $AREX_RUN_DIR/bmx.out || exit_code=2
grep "^OutResponses: $((nrequests_vh+2))$"  $AREX_RUN_DIR/bmx.out || exit_code=2
grep "^OutBytes404: $((nchars_404*2))$"     $AREX_RUN_DIR/bmx.out || exit_code=2
echo -----
echo Host=test gets one request
grep "^InRequestsGET: 1$" $AREX_RUN_DIR/bmx.out || exit_code=2
echo -----
echo "Host=test and Host=avirtualhost both get two wrong requests"
grep "OutBytes404: $nchars_404"             $AREX_RUN_DIR/bmx.out || exit_code=2
echo -----
echo "Host=avirtualhost supplied 200 responses (shown both in _GLOBAL_ and avirtualhost statistics)"
grep "OutBytes200: $((nchars_200*nrequests_vh))"             $AREX_RUN_DIR/bmx.out || exit_code=2
echo -----

exit $exit_code
