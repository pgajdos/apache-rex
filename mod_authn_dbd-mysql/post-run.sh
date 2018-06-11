mysql_dir=$AREX_RUN_DIR/mysql

echo
echo '>>> Shutting the mysql server down'
cat << EOF > $mysql_dir/shutdown.sql
SHUTDOWN;
EOF
mysql            --defaults-file=$mysql_dir/my.cnf --user root --password='roots_secret' < $mysql_dir/shutdown.sql
sleep 2
echo
