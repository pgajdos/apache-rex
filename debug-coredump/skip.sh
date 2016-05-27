# REASON: ulimit -c is zero or could not obtain coredump from coredumpctl
skip_exit_code=1
[ "$(ulimit -c)" == "0" ] && skip_exit_code=0
# System appears to write coredumps to systemd-coredump
# but do not have coredumpctl. I have no solution for 
# situation now.
[ "$AREX_HAVE_SYSTEMD_COREDUMP" == "1" ] && ! [ $(which coredumpctl 2>/dev/null) ] && skip_exit_code=0
exit $skip_exit_code

