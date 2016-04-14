for i in 1 2 3 4; do
  echo "customer-$i.example.com $AREX_RUN_DIR/customers/$i" >> $AREX_RUN_DIR/vhost.map
done

