# REASON: openssl has to support ALPN, curl has to support HTTP2 and prefork MPM not supported
# from error_log: ' The mpm module (prefork.c) is not supported by mod_http2. The
# mpm determines  how things are processed in your server. HTTP/2 has more demands
# in this regard  and the currently selected mpm will just not do.
#
# note: see mod_http2-push how to use nghttp2 instead of curl
exit $([ $AREX_OPENSSL_HAVE_ALPN -eq 0 ] || [ $AREX_MPM == "prefork" ] || [ $AREX_CURL_HAVE_HTTP2 -eq 0 ])

