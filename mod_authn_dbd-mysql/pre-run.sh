# create password database
mysql_dir=$AREX_RUN_DIR/mysql
mkdir -p $mysql_dir

john_sha1_passwd=$(htpasswd -nbs john johns_secret | head -n 1 | sed 's/john://')
hans_sha1_passwd=$(htpasswd -nbs hans hans_secret | head -n 1 | sed 's/hans://')


mkdir $mysql_dir/datadir $mysql_dir/datadir-private
cat << EOF > $mysql_dir/my.cnf
[client]
user   = $AREX_USER
socket = $mysql_dir/mysql.sock

[mysqld]
user=$AREX_USER
log-error        = $mysql_dir/mysqld.log
secure_file_priv = $mysql_dir/datadir-private
datadir          = $mysql_dir/datadir
server-id        = 1
socket           = $mysql_dir/mysql.sock
EOF

echo '>>> Initializing databases'
# --force is required by at least 10.0.38 on SLE 12 change root
mysql_install_db --defaults-file=$mysql_dir/my.cnf --force

echo '>>> Invoking mysqld'
mysqld           --defaults-file=$mysql_dir/my.cnf&
sleep 2

echo '>>> Creating authentication database'
mysqladmin       --defaults-file=$mysql_dir/my.cnf --user root password 'roots_secret'
mysqladmin       --defaults-file=$mysql_dir/my.cnf --user root --password='roots_secret' create httpd_auth

echo '>>> Creating authentication table'
cat << EOF > $mysql_dir/auth-db-setup.sql
GRANT SELECT, INSERT, UPDATE, DELETE ON httpd_auth.* TO 'auth_admin'@'localhost' IDENTIFIED BY 'auth_admin_secret';
GRANT SELECT, INSERT, UPDATE, DELETE ON httpd_auth.* TO 'auth_admin'@'localhost.localdomain' IDENTIFIED BY 'auth_admin_secret';
FLUSH PRIVILEGES;

USE httpd_auth;

CREATE TABLE password_table (
username varchar(255) not null,
passwd varchar(255),
groups varchar(255),
primary key (username)
);
EOF
mysql            --defaults-file=$mysql_dir/my.cnf --user root --password='roots_secret' < $mysql_dir/auth-db-setup.sql

echo '>>> Filling authentication table with example data'
cat << EOF > $mysql_dir/insert-users.sql
USE httpd_auth;
INSERT INTO password_table (username, passwd, groups) VALUES('john', '$john_sha1_passwd', 'employees');
INSERT INTO password_table (username, passwd, groups) VALUES('hans', '$hans_sha1_passwd', 'customers');
EOF
mysql  --defaults-file=$mysql_dir/my.cnf --user auth_admin --password='auth_admin_secret' < $mysql_dir/insert-users.sql

echo '>>> Testing the mysql is running and database is ready via password query'
cat << EOF > $mysql_dir/password-get.sql
USE httpd_auth;
SELECT passwd FROM password_table WHERE username = 'hans';
EOF
mysql  --defaults-file=$mysql_dir/my.cnf --user auth_admin --password='auth_admin_secret' \
                               < $mysql_dir/password-get.sql > $mysql_dir/test-password.txt
grep "$hans_sha1_passwd" $mysql_dir/test-password.txt && echo "SUCCESS" || echo "FAILURE";

echo
