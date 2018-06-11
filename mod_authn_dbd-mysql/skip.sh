# REASON: mysqld is already running
exit $(ps -A | grep -q mysqld)
