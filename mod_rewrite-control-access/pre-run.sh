cat << EOF > $AREX_RUN_DIR/hosts.deny
# hosts.deny
#
# ATTENTION! This is a map, not a list, even when we treat it as such.
# mod_rewrite parses it for key/value pairs
193.102.180.41 -
192.76.162.40  -
127.0.0.1      -
EOF

