# map needs to exist before apache starts
cat << EOF > $AREX_RUN_DIR/language_mirrors.txt
# language map
jp  http://localhost:$AREX_RUN_PORT1/doc/japanese/
fr  http://localhost:$AREX_RUN_PORT2/documentation/french/
can http://localhost:$AREX_RUN_PORT3/canadian/doc/
EOF

