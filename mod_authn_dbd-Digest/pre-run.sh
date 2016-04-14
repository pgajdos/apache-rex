# create password database
digest_passwd=$(echo -n 'john:Our Private Area:StrongPassword' | md5sum | sed 's:\s\+.*::')
sqlite $AREX_RUN_DIR/password.db << EOF
create table authn ("user" VARCHAR(64) primary key not null, "realm" VARCHAR(64) not null, "password" VARCHAR(64) not null);
insert into authn values ("john", "Our Private Area", "$digest_passwd");
EOF
mkdir -p $AREX_RUN_DIR/run
