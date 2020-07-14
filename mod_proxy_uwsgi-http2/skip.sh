# REASON: uwsgi does not have http or a python plugin
exit $([ -z "$AREX_UWSGI_PLUGIN_HTTP" -o -z "$AREX_UWSGI_PLUGIN_PYTHON" ])
