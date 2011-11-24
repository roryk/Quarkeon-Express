#!/usr/bin/env python

import tornado.httpserver
import tornado.ioloop
import tornado.options
import tornado.web
import tornado.escape
import logging
import tornado.auth
import datetime


import uuid

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
        current_user = self.get_current_user()

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

class CreateGameHandler(BaseJSONHandler):
    def initialize (self, dg):
        self.dg = dg

    def safe_post(self):
        players = tornado.json_decode(self.get_argument('players'))
        # players should be a json dict with a list of all the players email addresses
        map_width = self.get_argument('map_width')
        map_height = self.get_argument('map_width')
        planet_percentage = self.get_argument('planet_percentage')
        mean_uranium = self.get_argument('mean_uranium')
        starting_uranium = self.get_argument('starting_uranium')
        mean_planet_lifetime = self.get_argument('mean_planet_lifetime')

        result = self.dg.create_game(players, starting_uranium, map_width, map_height, planet_percentage, mean_uranium, mean_planet_life)
        self.write(result)


class InviteUserToGameHandler(BaseJSONHandler):
    def initialize (self, dg):
        self.dg = dg

    def safe_post(self):
        pass

class StartGameHandler(BaseJSONHandler):
    def initialize (self, dg):
        self.dg = dg

    def safe_post(self):
        pass

class BuyPlanetHandler(BaseJSONHandler):
    def initialize (self, dg):
        self.dg = dg

    def safe_post(self):
        pass

class EndTurnHandler(BaseJSONHandler):
    def initialize (self, dg):
        self.dg = dg

    def safe_post(self):
        pass
