#!/usr/bin/env python

import tornado.httpserver
import tornado.ioloop
import tornado.options
import tornado.web
import tornado.escape
import logging
import tornado.auth


import traceback

from .base import BaseHandler
from ..error import QEPermissionsError, QEIntegrityError 

class BaseJSONHandler (BaseHandler):

    def get (self):
        try: 
            self.safe_get()
        except QEIntegrityError, e:
            logging.error(traceback.format_exc())
            self.write({'status': 'error', 'type': 'integrity', 'message': str(e)})
        except QEPermissionsError, e:
            logging.error(traceback.format_exc())
            self.write({'status': 'error', 'type': 'permissions', 'message': str(e)})
        except Exception, e:
            logging.error(traceback.format_exc())
            self.write({'status': 'error', 'type': 'unknown', 'message': str(e)})

    def post (self):
        try: 
            self.safe_post()
        except QEIntegrityError, e:
            logging.error(traceback.format_exc())
            self.write({'status': 'error', 'type': 'integrity', 'message': str(e)})
        except QEPermissionsError, e:
            logging.error(traceback.format_exc())
            self.write({'status': 'error', 'type': 'permissions', 'message': str(e)})
        except Exception, e:
            logging.error(traceback.format_exc())
            self.write({'status': 'error', 'type': 'unknown', 'message': str(e)})


    def write (self, d):

        # if we got this far, and no one has
        # manually set an error, assume this ended OK
        if not d.has_key('status'):
            d.update({'status': 'ok'})

        super(BaseJSONHandler, self).write(tornado.escape.json_encode(d))

class AuthenticatedBaseJSONHandler (BaseJSONHandler):

    def prepare(self):
        if not self.current_user:
            self.write(tornado.escape.json_encode({'status': 'error', 'message': 'you must be logged into to hit this URL, hit /api/login'}))

class LoginHandler (BaseJSONHandler):
    def initialize (self, dg):
        self.dg = dg

    # we disable this ONLY for /login as /login may be the first HTTP request
    def check_xsrf_cookie(self):
        pass 

    def safe_post (self):

        email_address = self.get_argument("email_address")
        password = self.get_argument("password")

        self.xsrf_token 

        result = self.dg.login(email_address, password)

        if result['status'] == 'ok':

            cookie_data = {'id': result['id'],
                           'email_address': result['email_address'],
                           'name': result['name'],
                           }

            self.set_secure_cookie("user", 
                               tornado.escape.json_encode(cookie_data))

        self.write(result)


class LogoutHandler (BaseJSONHandler):
    
    def safe_get (self):
        
        if self.current_user:
            self.clear_cookie('user')

        self.redirect("/api/login")


class SignUpNewPlayerHandler(BaseJSONHandler):
    def initialize (self, dg):
        self.dg = dg

    def safe_post(self):

        name = self.get_argument('name')
        email = self.get_argument('email_address')
        password = self.get_argument('password')

        result = self.dg.add_player(name, email, password)
            
        self.write(result)

class CreateGameHandler(AuthenticatedBaseJSONHandler):
    def initialize (self, dg):
        self.dg = dg

    def safe_post(self):
        current_user = self.get_current_user()
        players = tornado.escape.json_decode(self.get_argument('players'))
        logging.info(players)
        # players should be a json dict with a list of all the players email addresses
        map_width = int(self.get_argument('map_width'))
        map_height = int(self.get_argument('map_width'))
        planet_percentage = int(self.get_argument('planet_percentage'))
        mean_uranium = int(self.get_argument('mean_uranium'))
        starting_uranium = int(self.get_argument('starting_uranium'))
        mean_planet_lifetime = int(self.get_argument('mean_planet_lifetime'))

        result = self.dg.create_game(players, starting_uranium, map_width, map_height, 
                    planet_percentage, mean_uranium, mean_planet_lifetime, current_user)

        self.write(result)


class LoadGameHandler(AuthenticatedBaseJSONHandler):
    def initialize (self, dg):
        self.dg = dg

    def safe_post(self):
        current_user = self.get_current_user()
        game_id = int(self.get_argument('game_id'))
        result = self.dg.get_game(game_id, current_user);

        self.write(result)

class GetMyGamesHandler(AuthenticatedBaseJSONHandler):
    def initialize (self, dg):
        self.dg = dg

    def safe_post(self):
        current_user = self.get_current_user()
        result = self.dg.get_my_game(current_user);

        self.write(result)


class GetStatusHandler(AuthenticatedBaseJSONHandler):
    # A routine for checking if it is the current users' turn in this game.
    def initialize (self, dg):
        self.dg = dg

    def safe_post(self):
        current_user = self.get_current_user()
        game_id = int(self.get_argument('game_id'))
        result = self.dg.get_status(game_id, current_user);

        self.write(result)

class InviteUserToGameHandler(AuthenticatedBaseJSONHandler):
    def initialize (self, dg):
        self.dg = dg

    def safe_post(self):
        pass

class StartGameHandler(AuthenticatedBaseJSONHandler):
    def initialize (self, dg):
        self.dg = dg

    def safe_post(self):
        pass

class BuyPlanetHandler(AuthenticatedBaseJSONHandler):
    def initialize (self, dg):
        self.dg = dg

    def safe_post(self):
        pass

class EndTurnHandler(AuthenticatedBaseJSONHandler):
    def initialize (self, dg):
        self.dg = dg

    def safe_post(self):
        pass
