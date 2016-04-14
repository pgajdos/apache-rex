# https://pypi.python.org/pypi/websocket-client/
import getopt
import sys
from websocket import create_connection

if __name__ == "__main__":
    opts, args = getopt.getopt(sys.argv[1:], "u:", ["url="])
    url = "ws://127.0.0.1/"
    for o, a in opts:
        if o in ("-u", "--url"):
            url = a
        else:
            assert False, "unhandled option"

    ws = create_connection(url)
    ws.send("hello world")
    result =  ws.recv()
    print "Received '%s'" % result

    ws.send("dlrow olleh")
    result =  ws.recv()
    print "Received '%s'" % result
    ws.close()

