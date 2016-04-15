# REASON: MATCH_ variables was introduced in 2.4.8 (see doc)
exit $([ $AREX_APACHE_VERSION -lt 020408 ])
