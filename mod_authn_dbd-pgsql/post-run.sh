pgsql_dir=$AREX_RUN_DIR/pgsql
echo
echo '>>> Shutting the postgres server down'
pg_ctl stop -D $pgsql_dir
echo
