. ../lib/mysql

mysql_dir=$AREX_RUN_DIR/mysql
mkdir -p $mysql_dir

mysql_create_config $mysql_dir
mysql_initialize_db $mysql_dir
mysql_invoke_mysqld $mysql_dir
mysql_create_database $mysql_dir 'testdb'

echo '>>> Creating test table'
cat << EOF > $mysql_dir/test-db-setup.sql
GRANT SELECT, INSERT, UPDATE, DELETE ON testdb.* TO 'dbuser'@'localhost' IDENTIFIED BY 'dbuserpw';
GRANT SELECT, INSERT, UPDATE, DELETE ON testdb.* TO 'dbuser'@'localhost.localdomain' IDENTIFIED BY 'dbuserpw';
FLUSH PRIVILEGES;

USE testdb;

CREATE TABLE testtab (
username varchar(255) not null,
name varchar(255),
surname varchar(255),
primary key (username)
);
EOF
mysql_invoke_script $mysql_dir $mysql_dir/test-db-setup.sql

echo '>>> Filling authentication table with example data'
cat << EOF > $mysql_dir/insert-users.sql
USE testdb;
INSERT INTO testtab (username, name, surname) VALUES('john', 'John', 'Doe');
INSERT INTO testtab (username, name, surname) VALUES('hans', 'Hans', 'Raw');
EOF
mysql_invoke_script $mysql_dir $mysql_dir/insert-users.sql dbuser dbuserpw

echo '>>> Testing the mysql is running and database'
cat << EOF > $mysql_dir/password-get.sql
USE testdb;
SELECT surname FROM testtab WHERE username = 'hans';
EOF
mysql_invoke_script $mysql_dir $mysql_dir/password-get.sql dbuser dbuserpw \
                               > $mysql_dir/test-fetch.txt
grep "Raw" $mysql_dir/test-fetch.txt && echo "SUCCESS" || echo "FAILURE";
echo

mkdir -p $AREX_DOCUMENT_ROOT
for i in all_users user_info; do
  cp $i.php.in $AREX_DOCUMENT_ROOT/$i.php
  sed -i "s:@mysql_socket@:$(mysql_socket_path):" $AREX_DOCUMENT_ROOT/$i.php
done


