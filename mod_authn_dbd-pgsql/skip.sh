# REASON: postgres is already running
exit $(ps -A | grep -q postgres)
