# REASON: curl does not have --resolve
exit $([ $AREX_CURL_HAVE_RESOLVE -eq 0 ])
