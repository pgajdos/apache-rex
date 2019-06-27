exit_code=0

cp index.rvt table.rvt $AREX_DOCUMENT_ROOT/

echo "[1] rivet TCL handler was invoked"
curl -s http://localhost:$AREX_PORT/ | grep 'Hello World' || exit_code=1 
curl -s http://localhost:$AREX_PORT/table.rvt \
  | grep '<td bgcolor="dfdfdf" > 223 223 223 </td>'       || exit_code=2

exit $exit_code
