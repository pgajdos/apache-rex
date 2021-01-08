# REASON: curl does not have --resolve
exit $([ $AREX_CURL_HAVE_RESOLVE -eq 0 ] || [ $AREX_APACHE_VERSION -gt 20443 ])
