. ../lib/mysql

# create password database
mysql_dir=$AREX_RUN_DIR/mysql
mkdir -p $mysql_dir

john_sha1_passwd=$(htpasswd -nbs john johns_secret | head -n 1 | sed 's/john://')
hans_sha1_passwd=$(htpasswd -nbs hans hans_secret | head -n 1 | sed 's/hans://')

mysql_create_config $mysql_dir
mysql_initialize_db $mysql_dir
mysql_invoke_mysqld $mysql_dir
mysql_create_database $mysql_dir 'httpd_auth'

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
mysql_invoke_script $mysql_dir $mysql_dir/auth-db-setup.sql

echo '>>> Filling authentication table with example data'
cat << EOF > $mysql_dir/insert-users.sql
USE httpd_auth;
INSERT INTO password_table (username, passwd, groups) VALUES('john', '$john_sha1_passwd', 'employees');
INSERT INTO password_table (username, passwd, groups) VALUES('hans', '$hans_sha1_passwd', 'customers');
EOF
mysql_invoke_script $mysql_dir $mysql_dir/insert-users.sql auth_admin 'auth_admin_secret'

echo '>>> Testing the mysql is running and database is ready via password query'
cat << EOF > $mysql_dir/password-get.sql
USE httpd_auth;
SELECT passwd FROM password_table WHERE username = 'hans';
EOF
mysql_invoke_script $mysql_dir $mysql_dir/password-get.sql auth_admin 'auth_admin_secret' \
                               > $mysql_dir/test-password.txt
grep "$hans_sha1_passwd" $mysql_dir/test-password.txt && echo "SUCCESS" || echo "FAILURE";

echo

