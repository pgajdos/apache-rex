# REASON: needs curl --resolve
exit $([ $AREX_CURL_HAVE_RESOLVE -eq 0 ])

