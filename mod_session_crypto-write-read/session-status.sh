#!/bin/bash

echo "Content-type: text/plain"
if [ -n "$HTTP_SESSION" ]; then
  echo
  echo "Decrypted Cookie: $HTTP_SESSION"
else
  echo "X-Replace-Session: $QUERY_STRING"
  echo 
  echo "cookie sent"
fi

