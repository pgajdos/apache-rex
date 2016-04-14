mkdir -p $AREX_RUN_DIR/run
# htdigest created by 
#  $ htdigest -c htdigest 'Restricted Area' john
# (htdigest does not have batch mode; realm has to be AuthName)
cp htdigest $AREX_RUN_DIR/htdigest
