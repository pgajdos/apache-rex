exit_code=0

echo "[1] recode ISO-8859-2 text to UTF-8 text"
utf8_string='Loď čeří kýlem tůň obzvlášť v Grónské úžině.'
echo $utf8_string | iconv --from-code=UTF-8 --to-code=ISO-8859-2 > $AREX_DOCUMENT_ROOT/index.html
returned_string=$(curl -s http://localhost:$AREX_PORT/)
echo "original string: $utf8_string"
echo "returned string: $returned_string"
[ "$returned_string" == "$utf8_string" ] || exit_code=1

exit $exit_code
