# REASON: openssl has to support ALPN, prefork not supported
# from error_log: ' The mpm module (prefork.c) is not supported by mod_http2. The
# mpm determines  how things are processed in your server. HTTP/2 has more demands
# in this regard  and the currently selected mpm will just not do.
exit $([ $AREX_OPENSSL_HAVE_ALPN -eq 0 ] || [ $AREX_MPM == "prefork" ])

