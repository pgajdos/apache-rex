exit_code=0

echo "[1] insert into table, get whole column from the table"
curl -s http://localhost:$AREX_PORT/all_users.php > $AREX_RUN_DIR/all_users.txt
grep 'add honza.*true'  $AREX_RUN_DIR/all_users.txt || exit_code=1
grep 'john'             $AREX_RUN_DIR/all_users.txt || exit_code=1

echo "[2] get a column"
curl -s http://localhost:$AREX_PORT/user_info.php?un=hans > $AREX_RUN_DIR/user_info.txt
grep 'hans Hans Raw' $AREX_RUN_DIR/user_info.txt    || exit_code=2

exit $exit_code
