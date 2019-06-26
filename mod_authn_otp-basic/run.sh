exit_code=0

# see https://github.com/archiecobbs/mod-authn-otp/blob/master/README.md
# for details

# secret token
TEST_TOKEN='a4d8acbddef654fccc418db4cc2f85cea6339f00'
TEST_USER='wilma'

mkdir -p $AREX_RUN_DIR/htdocs/protected
echo 'RESTRICTED by OTP' > $AREX_RUN_DIR/htdocs/protected/index.html
# create initial UsersFile
echo "HOTP $TEST_USER - $TEST_TOKEN" > $AREX_RUN_DIR/users-file


pass=$(otptool -c 0 $TEST_TOKEN | sed 's@.*:[ \t]*\([0-9]*\)[ \t]*.*@\1@')

echo "[1] testing first password, access allowed"
curl -s -u $TEST_USER:$pass http://localhost:$AREX_PORT/protected/ | grep 'RESTRICTED' || exit_code=1

# next access with the same password within the linger time should be allowed
echo "[2] testing first password in linger time"
curl -s -u $TEST_USER:$pass http://localhost:$AREX_PORT/protected/ | grep 'RESTRICTED' || exit_code=2

# sleeping to get past the linger time
sleep 2

# next access with the same password after linger time should not be allowed
echo "[3] testing first password after linger time"
curl -s -u $TEST_USER:$pass http://localhost:$AREX_PORT/protected/ | grep '<title>.*401.*</title>' || exit_code=3

# figure out second password (counter increased by one)
pass=$(otptool -c 1 $TEST_TOKEN | sed 's@.*:[ \t]*\([0-9]*\)[ \t]*.*@\1@')

echo "[4] testing second password"
curl -s -u $TEST_USER:$pass http://localhost:$AREX_PORT/protected/ | grep 'RESTRICTED' || exit_code=4

# increasing counter again, generating new password
pass=$(otptool -c 2 $TEST_TOKEN | sed 's@.*:[ \t]*\([0-9]*\)[ \t]*.*@\1@')

# access with the third password should be allowed even if linger time
# of the previous one have not expired
echo "[5] testing next password in linger time of previous password"
curl -s -u $TEST_USER:$pass http://localhost:$AREX_PORT/protected/ | grep 'RESTRICTED' || exit_code=5

exit $exit_code
