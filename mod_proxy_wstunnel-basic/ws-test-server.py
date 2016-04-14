# https://developer.mbed.org/cookbook/Websockets-Server
import tornado.httpserver
import tornado.websocket
import tornado.ioloop
import tornado.web
import socket

import getopt
import sys
import os

class WSHandler(tornado.websocket.WebSocketHandler):
    def open(self):
        print 'new connection'

    def on_message(self, message):
        print 'message received:  %s' % message
        # Reverse Message and send it back
        print 'sending back message: %s' % message[::-1]
        self.write_message(message[::-1])

    def on_close(self):
        print 'connection closed'

    def check_origin(self, origin):
        return True



if __name__ == "__main__":
    opts, args = getopt.getopt(sys.argv[1:], "i:p:u:d:", ["ip=", "port=", "uri=", "pid-file="])
    ip      = "127.0.0.1"
    port    = "8080"
    uri     = "/"
    pidfile = ""
    for o, a in opts:
        if   o in ("-i", "--ip"):
            ip = a
        elif o in ("-p", "--port"):
            port = a
        elif o in ("-u", "--uri"):
            uri = a
        elif o in ("-d", "--pid-file"):
            pidfile = a
        else:
            assert False, "unhandled option"
 
    pid = os.getpid()
    if pidfile != "":
        f = open(pidfile, "w")
        print >>f, str(pid)
        f.close()
    print 'process id: %s' % pid

    application = tornado.web.Application([(uri, WSHandler),])
    http_server = tornado.httpserver.HTTPServer(application)
    http_server.listen(int(port), address=ip)
    print 'starting websocket server at %s:%s' % (ip, port)
    tornado.ioloop.IOLoop.instance().start()

