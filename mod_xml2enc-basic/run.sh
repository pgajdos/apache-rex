exit_code=0
mkdir -p $AREX_RUN_DIR/htdocs-backend

echo "[1] encoding taken from xml2EncDefault"
utf8_string='Loď čeří kýlem tůň obzvlášť v Grónské úžině.'
echo "<html><head></head><body>$utf8_string</body></html>" \
  | iconv --from-code=UTF-8 --to-code=ISO-8859-2 > $AREX_RUN_DIR/htdocs-backend/czech.html
returned_string=$(curl -s http://localhost:$AREX_PORT2/pangrams/czech.html)
echo original string: $utf8_string
echo returned string: $returned_string
[[ "$returned_string" =~ "$utf8_string" ]] || exit_code=1

echo "[2] encoding taken from <meta>"
utf8_string='Victor jagt zwölf Boxkämpfer quer über den großen Sylter Deich.'
# currently not working with html5 <meta charset="iso-8859-2">
echo "<html><head><meta http-equiv=\"content-type\" content=\"text/html; charset=iso-8859-2\"/></head><body>$utf8_string</body></html>" \
  | iconv --from-code=UTF-8 --to-code=ISO-8859-2 > $AREX_RUN_DIR/htdocs-backend/german.html
returned_string=$(curl -s http://localhost:$AREX_PORT3/pangrams/german.html)
echo original string: $utf8_string
echo returned string: $returned_string
[[ "$returned_string" =~ "$utf8_string" ]] || exit_code=2

echo "[3] encoding taken from backend response header"
utf8_string='Kŕdeľ ďatľov učí koňa žrať kôru.'
echo "<html><head></head><body>$utf8_string</body></html>" \
  | iconv --from-code=UTF-8 --to-code=ISO-8859-2 > $AREX_RUN_DIR/htdocs-backend/slovak.html
returned_string=$(curl -s http://localhost:$AREX_PORT5/pangrams/slovak.html)
echo original string: $utf8_string
echo returned string: $returned_string
[[ "$returned_string" =~ "$utf8_string" ]] || exit_code=3

exit $exit_code
