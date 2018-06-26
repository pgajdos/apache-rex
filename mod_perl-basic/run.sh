exit_code=0


echo "[1] Apache2::Status usage"
curl -s http://localhost:$AREX_PORT/perl-status?inc | grep 'Apache2::Const' || exit_code=1

# https://perl.apache.org/docs/2.0/user/config/config.html#Examples
echo "[2] run a perl module"
perl_lib=$AREX_RUN_DIR/perl-lib
mkdir -p  $perl_lib/MyApache2
cp PrintEnv.pm $perl_lib/MyApache2
curl -s http://localhost:$AREX_PORT/print-env | grep 'HTTP_HOST' || exit_code=2

# https://www.safaribooksonline.com/library/view/practical-mod_perl/0596002270/ch02s06.html
echo "[3] run unaltered CGI scrips under mod_perl"
cgi_dir=$AREX_RUN_DIR/cgi-bin
mkdir -p $cgi_dir
cp test.pl $cgi_dir
chmod 0700 $cgi_dir/test.pl
curl -s http://localhost:$AREX_PORT/cgi-bin/test.pl      | grep '^perl rules!$'       || exit_code=3
curl -s http://localhost:$AREX_PORT/perl-cgi-bin/test.pl | grep '^mod_perl. rules!$' || exit_code=3


exit $exit_code

