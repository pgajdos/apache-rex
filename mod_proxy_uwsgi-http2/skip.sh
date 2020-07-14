# REASON: uwsgi does not have http or a python plugin, prefork not supported by mod_http2
exit $([ -z "$AREX_UWSGI_PLUGIN_HTTP" -o -z "$AREX_UWSGI_PLUGIN_PYTHON" ] || [ $AREX_MPM == "prefork" ])
