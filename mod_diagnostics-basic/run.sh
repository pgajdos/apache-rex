exit_code=0

function log_entries
{
  req_ident=$1
  # utilize '\t' in the mod_diagnostics error_log messages
  output=0
  while read -r line; do
    [[ "$line" =~ BEGIN.*$req_ident ]] && output=1
    [ $output -eq 1 ] && printf "$line\n"; 
    [[ "$line" =~ END.*$req_ident ]]   && output=0
  done < $AREX_RUN_DIR/error_log
  
}

mkdir $AREX_DOCUMENT_ROOT/{a,b,c,d,e}

echo "[1] no filter between log filters"
echo "brigade is intact (FILE EOS)"
echo -n 'Have a lot of fun...' > $AREX_DOCUMENT_ROOT/a/test.html
curl http://localhost:$AREX_PORT/a/test.html
echo
log_entries '/a/'             | tee $AREX_RUN_DIR/error_log.1
[ $(grep -c FILE $AREX_RUN_DIR/error_log.1) -eq 2 ] || exit_code=1

echo
echo "[2] SUBSTITUTE filter between log filters, no Substitute directive, though"
echo "    data bucket changes type from FILE to TRANSIENT"
echo -n 'Have a lot of fun...' > $AREX_DOCUMENT_ROOT/b/test.html
curl http://localhost:$AREX_PORT/b/test.html
echo
log_entries '/b/'             | tee $AREX_RUN_DIR/error_log.2
[ $(grep -c TRANSIENT $AREX_RUN_DIR/error_log.2) -eq 1 ] || exit_code=2

echo
echo "[3] SUBSTITUTE filter between log filters, regexp does not match"
echo "    data bucket changes type from FILE to TRANSIENT"
echo -n 'Have a lot of fun...' > $AREX_DOCUMENT_ROOT/c/test1.html
curl http://localhost:$AREX_PORT/c/test1.html
echo
log_entries '/c/test1.html'   | tee $AREX_RUN_DIR/error_log.3
[ $(grep -c TRANSIENT $AREX_RUN_DIR/error_log.3) -eq 1 ] || exit_code=3

echo
echo "[4] SUBSTITUTE filter between log filters, regexp matches"
echo "    data bucket changes type from FILE (20 bytes) to three TRANSIENT ones (7+1+12 bytes)"
echo -n 'Have a Lot of fun...' > $AREX_DOCUMENT_ROOT/c/test2.html
curl http://localhost:$AREX_PORT/c/test2.html
echo
log_entries '/c/test2.html'   | tee $AREX_RUN_DIR/error_log.4
[ $(grep -c TRANSIENT $AREX_RUN_DIR/error_log.4) -eq 3 ] || exit_code=4

echo
echo "[5] SUBSTITUTE filter between log filters, two Substitute, both regexps match"
echo "    data bucket changes type from FILE (20 bytes) to POOL (20 bytes)"
echo -n 'have a lot of FUN...' > $AREX_DOCUMENT_ROOT/d/test.html
curl http://localhost:$AREX_PORT/d/test.html
echo
log_entries '/d/'             | tee $AREX_RUN_DIR/error_log.5
[ $(grep -c POOL $AREX_RUN_DIR/error_log.5) -eq 1 ] || exit_code=5

echo
echo "[6] DATA filter between log filters"
echo "    data bucket transforms type from FILE (20000 bytes) to HEAP (87 bytes) and IMMORTAL (10 bytes), POOL (8 bytes),"
echo "    which look like a overhead cost"
for i in $(seq 1 1000); do
  echo -n 'Have a lot of fun...' >> $AREX_DOCUMENT_ROOT/e/test.data
done
curl -H "Accept-Encoding: gzip,deflate" http://localhost:$AREX_PORT/e/test.data >/dev/null 2>&1
log_entries '/e/'             | tee $AREX_RUN_DIR/error_log.6
[ $(grep -c HEAP $AREX_RUN_DIR/error_log.6) -eq 1 ] || exit_code=6


