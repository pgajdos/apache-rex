# REASON: curl does not have --resolve or not using prefork MPM
exit $([ $AREX_CURL_HAVE_RESOLVE -eq 0 -o ! $AREX_MPM == 'prefork' ])
