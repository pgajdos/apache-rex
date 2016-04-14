exit_code=0

mkdir $AREX_RUN_DIR/ftpmirror
echo  'FTP HELLO' > $AREX_RUN_DIR/ftpmirror/welcome

# run ftp daemon
cat << EOF > $AREX_RUN_DIR/vsftpd.conf
anonymous_enable=YES
anon_root=$AREX_RUN_DIR/ftpmirror
anon_world_readable_only=YES
listen=YES
listen_address=127.0.0.1
listen_port=$AREX_FTP_PORT
run_as_launching_user=YES
EOF
vsftpd $AREX_RUN_DIR/vsftpd.conf&
sleep 1


echo "[1] demonstrate directory listing on ftp server"
curl -s http://localhost:$AREX_RUN_PORT/ | grep '<a href="welcome">welcome</a>' || exit_code=1

echo "[2] show file contents on ftp server"
curl -s http://localhost:$AREX_RUN_PORT/welcome | grep 'FTP HELLO' || exit_code=2


# stop ftp daemon
vsftpd_pid=$(lsof -i | grep ":$AREX_FTP_PORT (LISTEN)" | sed 's:[^ ]\+[ ]\+\([0-9]\+\).*:\1:')
kill -TERM $vsftpd_pid

exit $exit_code
