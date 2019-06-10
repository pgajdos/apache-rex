exit_code=0

. ../lib/processman

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
xferlog_enable=YES
vsftpd_log_file=$AREX_RUN_DIR/vsftpd.log
EOF
if [ $AREX_VSFTPD_VERSION -ge 300 ]; then
  # https://wiki.archlinux.org/index.php/Very_Secure_FTP_Daemon#vsftpd:_Error_421_Service_not_available,_remote_server_has_closed_connection
  echo 'seccomp_sandbox=NO' >> $AREX_RUN_DIR/vsftpd.conf
fi

######
echo -n 'Starting vsftpd ... '
vsftpd $AREX_RUN_DIR/vsftpd.conf&
sleep 3
vsftpd_pid=$(get_pid_port $AREX_FTP_PORT)
if [ -z "$vsftpd_pid" ]; then
  echo "FAILED."
  echo +++++++ vsftpd.log ++++++++
  cat $AREX_RUN_DIR/vsftpd.log
  echo +++++++ vsftpd.log ++++++++
  exit 1
fi
echo $vsftpd_pid
echo
########

echo "[1] demonstrate directory listing on ftp server"
curl -s http://localhost:$AREX_PORT/ | grep '<a href="welcome">welcome</a>' || exit_code=1

echo "[2] show file contents on ftp server"
curl -s http://localhost:$AREX_PORT/welcome | grep 'FTP HELLO' || exit_code=2

########
if [ $exit_code -gt 0 ]; then
  echo +++++++ vsftpd.log ++++++++
  cat $AREX_RUN_DIR/vsftpd.log
  echo +++++++ vsftpd.log ++++++++
fi

echo
echo -n 'Stopping vsftpd ... '
kill_pid_port $vsftpd_pid $AREX_FTP_PORT && echo 'done.' || echo 'FAILED.'
########

exit $exit_code
