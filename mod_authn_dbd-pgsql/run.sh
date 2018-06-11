exit_code=0

mkdir -p $AREX_DOCUMENT_ROOT/{private,company}
echo "Secret DATA" > $AREX_DOCUMENT_ROOT/private/secret.html
echo "Company Secret DATA" > $AREX_DOCUMENT_ROOT/company/secret.html

echo "[1] access allowed for a customer to customer area"
curl -u hans:hans_secret  -s http://localhost:$AREX_PORT/private/secret.html | grep 'Secret DATA'  || exit_code=1
echo "[2] access denied for a customer to company area"
curl -u hans:hans_secret  -s http://localhost:$AREX_PORT/company/secret.html | grep '401.*uthoriz' || exit_code=2
echo "[3] access allowed for a employee to company area"
curl -u john:johns_secret -s http://localhost:$AREX_PORT/company/secret.html | grep 'Company Secret DATA' || exit_code=3

exit $exit_code
