# in time of writing, intended for reqtimeout module testing
# it sends a single POST request with a delay in header or body
# 
# refer to https://github.com/gkbrk/slowloris/blob/master/slowloris.py
#          https://download.pureftpd.org/misc/slowloris.pl
import socket
import time
import sys

if len(sys.argv) < 4:
    print("")
    print("usage: {0} <host> <port> <uri> <delay> <type>".format(sys.argv[0]))
    print("")
    print("       host:     server host name or ip")
    print("       port:     port where server listen")
    print("       uri:      uri requested")
    print("       delay:    amount of time in seconds to wait ")
    print("                 before sending rest of the request")
    print("       type:     in which phase of sending request wait")
    print("                 possibilities: header, body")
    print("")
    print("       if no delay and type supplied, the request is sent without any delay")
    print("")
    sys.exit()

host  = sys.argv[1]
port  = int(sys.argv[2])
uri   = sys.argv[3]
delay = int(sys.argv[4]) if len(sys.argv) >= 5 else 0
dtype = sys.argv[5] if len(sys.argv) >= 6 else ''

body    = "request body"
    
print("host:    {0}".format(host))
print("port:    {0}".format(port))
print("uri:     {0}".format(uri))
print("delay:   {0}".format(delay))
print("type:    {0}".format(dtype))
    
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((host, port))

try:
    s.send("POST {0} HTTP/1.1\r\n".format(uri))
    s.send("Host: {0}:{1}\r\n".format(host, port))
    s.send("User-Agent: curl/7.47.0\r\n")
    s.send("Accept: */*\r\n")
    s.send("Content-Length: {0}\r\n".format(len(body)+1))
    if dtype == 'header':
        time.sleep(delay)
    s.send("\r\n")
    if dtype == 'body':
        time.sleep(delay)
    s.send(body + "\r\n")
except socket.error, e:
    print "(INTENDED) Socket Error: ", e

data = s.recv(1024)
print data
s.close()

