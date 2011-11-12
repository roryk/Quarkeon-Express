#!/usr/bin/env python
import tornado.web

class BaseHandler(tornado.web.RequestHandler):
    def get_current_user(self):
        uc = self.get_secure_cookie("user")
        ret = None
        if uc is not None:
            ret = tornado.escape.json_decode(uc)
           
        return ret 
