# REASON: ulimit -c is zero or does not have coredumpctl (or permissions)
skip_exit_code=1
[ "$(ulimit -c)" == "0" ] && skip_exit_code=0
# System appears to write coredumps to systemd-coredump
# but do not have coredumpctl abilities.
[ "$AREX_HAVE_SYSTEMD_COREDUMP" == "0" ] && skip_exit_code=0
exit $skip_exit_code

