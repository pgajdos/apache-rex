# create dummy password checker
cat << EOF > $AREX_RUN_DIR/dummy-auth
#!/bin/bash
read user
read passwd
if [ "\$user" == "\$passwd" ]; then
  exit 0
else
  exit 1
fi
EOF
chmod 755 $AREX_RUN_DIR/dummy-auth

