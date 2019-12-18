# create password database
pgsql_dir=$AREX_RUN_DIR/pgsql
mkdir -p $pgsql_dir

john_sha1_passwd=$(htpasswd -nbs john johns_secret | head -n 1 | sed 's/john://')
hans_sha1_passwd=$(htpasswd -nbs hans hans_secret | head -n 1 | sed 's/hans://')

echo '>>> Initializing databases'
pg_ctl initdb -D $pgsql_dir

echo '>>> Configuration'
echo "port = $AREX_PGSQL_PORT"                >> $pgsql_dir/postgresql.conf
echo "unix_socket_directories = '$pgsql_dir'" >> $pgsql_dir/postgresql.conf

echo '>>> Invoking postgresql'
pg_ctl start  -D $pgsql_dir -l $pgsql_dir/pgsql.log

echo '>>> Creating authentication database'
createdb --host='localhost' --port "$AREX_PGSQL_PORT" httpd_auth

echo '>>> Creating authentication table'
cat << EOF > $pgsql_dir/create-auth-table.sql
CREATE TABLE password_table (
username varchar(255) not null,
passwd varchar(255),
groups varchar(255),
primary key (username)
);
EOF
psql --host='localhost' --port "$AREX_PGSQL_PORT" -f $pgsql_dir/create-auth-table.sql -d httpd_auth

echo '>>> Filling authentication table with example data'
cat << EOF > $pgsql_dir/insert-users.sql
INSERT INTO password_table (username, passwd, groups) VALUES('john', '$john_sha1_passwd', 'employees');
INSERT INTO password_table (username, passwd, groups) VALUES('hans', '$hans_sha1_passwd', 'customers');
EOF
psql --host='localhost' --port "$AREX_PGSQL_PORT" -f $pgsql_dir/insert-users.sql -d httpd_auth

echo '>>> Testing the postgres is running and database is ready via password query'
cat << EOF > $pgsql_dir/password-get.sql
SELECT passwd FROM password_table WHERE username = 'hans';
EOF
psql --host='localhost' --port "$AREX_PGSQL_PORT" -f $pgsql_dir/password-get.sql -d httpd_auth > $pgsql_dir/test-password.txt
grep "$hans_sha1_passwd" $pgsql_dir/test-password.txt && echo "SUCCESS" || echo "FAILURE";

echo
