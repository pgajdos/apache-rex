exit_code=0

cp hooks.lua $AREX_RUN_DIR

echo '<h1>Index Page</h1>' > $AREX_DOCUMENT_ROOT/index.html
cat << EOF                 > $AREX_DOCUMENT_ROOT/hello-world.c
#include <stdio.h>

int main(void)
{
  printf("Hello world!")
  return 0;
}
EOF

echo "[1] c source is served as html page with escaped characters in the code"
curl -s http://localhost:$AREX_PORT/hello-world.c > hello-world.c.html
grep -q '&lt;stdio.h&gt' hello-world.c.html | exit_code=1
cat hello-world.c.html
echo

echo "[2] html page have not escaped html symbols"
curl -s http://localhost:$AREX_PORT/index.html    | grep '<h1>Index Page</h1>' || exit_code=2

exit $exit_code
