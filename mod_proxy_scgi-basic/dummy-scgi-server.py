# see site-packages/scgi/scgi_server.py for details
from scgi import scgi_server
import sys

def main():
    if len(sys.argv) == 2:
        port = int(sys.argv[1])
    else:
        port = scgi_server.SCGIServer.DEFAULT_PORT
    scgi_server.SCGIServer(port=port).serve()

if __name__ == "__main__":
    main()

