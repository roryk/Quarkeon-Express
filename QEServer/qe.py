#!/usr/bin/env python

import tornado.httpserver
import tornado.ioloop
import tornado.options
import tornado.web
import tornado.escape
import logging
import tornado.auth

from tornado.template import Loader

from tornado.options import define, options

from qe.dataguy import DataGuy
import qe.handlers.json


define("port", default=8888, help="run on the given port", type=int)
define("sqlite_db", default="./database/qe.db", help="path to sqliteDB", type=str)

def main():
    tornado.options.parse_command_line()
    # shorten the namespace for ease of reference. 
    json = qe.handlers.json
    
    settings = {
        "cookie_secret": "ALKJSLAKJDLKAJSDLKAJSDLKAJSDLKJASDNEBBEBENNMMEQQERTT",
        "xsrf_cookies": True,
    }

    logging.info("sqlite_db: %s" % (options.sqlite_db))

    dg = {'dg': DataGuy(options.sqlite_db)}

    application = tornado.web.Application([

        # REST interface, everything under /api
        # user managment
        (r"/api/signupnewplayer", json.SignUpNewPlayerHandler, dg),
        (r"/api/login", json.LoginHandler, dg),

        # game creation
        (r"/api/creategame", json.CreateGameHandler, dg),
        (r"/api/inviteusertogame", json.InviteUserToGameHandler, dg),
        (r"/api/startgame", json.StartGameHandler, dg),

        # game play
        (r"/api/buyplanet", json.BuyPlanetHandler, dg),
        (r"/api/endturn", json.EndTurnHandler, dg),

    ], **settings)

    http_server = tornado.httpserver.HTTPServer(application)
    http_server.listen(options.port)
    logging.info("Listening on port %d", options.port)
    tornado.ioloop.IOLoop.instance().start()

if __name__ == "__main__":
    main()
