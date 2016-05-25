# REASON: openssl has to support ALPN
exit $([ $AREX_OPENSSL_HAVE_ALPN -eq 0 ])

