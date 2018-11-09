# REASON: curl does not have --resolve or does not have --cert-status
exit $([ $AREX_CURL_HAVE_RESOLVE -eq 0 -o $AREX_CURL_HAVE_CERT_STATUS -eq 0 ])
