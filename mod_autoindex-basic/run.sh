exit_code=0
echo "[1] directory autoindex output"
cp -r data/* includes icons  $AREX_DOCUMENT_ROOT
curl -s http://localhost:$AREX_RUN_PORT/ > $AREX_RUN_DIR/i.html
(grep '<title>Index of /</title>' $AREX_RUN_DIR/i.html && 
 grep '<th>Name</th>' $AREX_RUN_DIR/i.html && 
 grep '/icons/image.png.*alt="\[IMG\].*href="apache_pb.svg".*apache_pb.svg' $AREX_RUN_DIR/i.html &&
 grep '/icons/compressed.png.*alt="\[CMP\]".*href="archive.tar.gz".*archive.tar.gz' $AREX_RUN_DIR/i.html &&
 grep '/icons/dir.png.*alt="\[DIR\].*href="icons/".*icons/' $AREX_RUN_DIR/i.html &&
 grep '/icons/text.png.*alt="\[TXT\]".*href="text.txt".*text.txt' $AREX_RUN_DIR/i.html &&
 grep '/icons/unknown.png.*alt="\[   \]".*href="unknown".*unknown' $AREX_RUN_DIR/i.html) || exit_code=1
exit $exit_code
