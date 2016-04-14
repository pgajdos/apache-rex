# REASON: need python-tornado and python-websocket-client
exit $([ $AREX_HAVE_PYTHON_TORNADO != "1" ] || [ $AREX_HAVE_PYTHON_WEBSOCKET_CLIENT != "1" ] )

