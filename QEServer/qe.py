#!/usr/bin/env python

import tornado.httpserver
import tornado.ioloop
import tornado.options
import tornado.web
import tornado.escape
import logging
import tornado.auth

from tornado.options import define, options

from qe.dataguy import DataGuy
import qe.handlers.json


define("port", default=8888, help="run on the given port", type=int)
define("sqlite_db", default="./database/qe.db", help="path to sqliteDB", type=str)
define("init_db", default=False, help="Re-initialize the database (destructive!)", type=bool)

def main():
    tornado.options.parse_command_line()
    # shorten the namespace for ease of reference. 
    json = qe.handlers.json
    
    settings = {
        "cookie_secret": "ALKJSLAKJDLKAJSDLKAJSDLKAJSDLKJASDNEBBEBENNMMEQQERTT",
        "xsrf_cookies": True,
        "debug": True
    }

    logging.info("sqlite_db: %s" % (options.sqlite_db))

    dg = {'dg': DataGuy(options.sqlite_db)}

    application = tornado.web.Application([

####
# Need to add: map generation, map data model, retrieving an old
# game from the server (w/ map & state), creating a game, starting
# a game, taking turns, inviting users to play the game, handling
# winning and losing, notifing the players of their turn happening.
####

        # REST interface, everything under /api
        # user managment
        (r"/api/signupnewplayer", json.SignUpNewPlayerHandler, dg),
        (r"/api/login", json.LoginHandler, dg),

        # game creation
        (r"/api/creategame", json.CreateGameHandler, dg),
        (r"/api/inviteusertogame", json.InviteUserToGameHandler, dg),
        (r"/api/startgame", json.StartGameHandler, dg),



        # game management, to be implemented once a single game works
        (r"/api/loadgame", json.LoadGameHandler, dg),
        (r"/api/getstatus", json.GetStatusHandler, dg),
        (r"/api/getmygames", json.GetMyGamesHandler, dg),
#        (r"/api/getgames", json.GetGamesHandler, dg),

        # game play
        (r"/api/buyplanet", json.BuyPlanetHandler, dg),
        (r"/api/endturn", json.EndTurnHandler, dg),

    ], **settings)


    if (options.init_db):
        logging.info("Wiping DB and initing")
        dg['dg'].init_new_db()
        return 


    http_server = tornado.httpserver.HTTPServer(application)
    http_server.listen(options.port)
    logging.info("Listening on port %d", options.port)
    tornado.ioloop.IOLoop.instance().start()

if __name__ == "__main__":
    main()
