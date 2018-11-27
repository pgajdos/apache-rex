# REASON http://php.net/manual/en/faq.installation.php#faq.installation.apache2
exit $([ ! $AREX_MPM == 'prefork' ])
