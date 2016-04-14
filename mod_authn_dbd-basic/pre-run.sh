# create password database
sha1_passwd=$(htpasswd -nbs john StrongPassword | head -n 1 | sed 's/john://')
sqlite $AREX_RUN_DIR/password.db << EOF
create table authn ("user" VARCHAR(64) primary key not null, "password" VARCHAR(64) not null);
insert into authn (user, password) values ("john", "$sha1_passwd");
EOF

