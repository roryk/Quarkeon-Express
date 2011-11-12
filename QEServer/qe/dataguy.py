#!/usr/bin/env python

from .error import QEPermissionsError
from .error import QEIntegrityError

import logging
import datetime

import sqlite3

import uuid

import traceback
import copy
import random

import urlparse


# XXX we use this just for the JSON library; we need to refactor this out
import tornado

# XXX we set the port in qe.py as well, which is a bug waiting to happen.
# since we need to keep them in sync. Not a problem when we switch to port 80
QE_BASE_URL = "http://localhost:8888"

def qe_url (path, query_params=None, base_url=QE_BASE_URL):
   url = urlparse.urljoin(base_url, path)
   if query_params:
      url += "?%s" % ('&'.join(["%s=%s" % (i[0], i[1]) for i in query_params.items()]))

   return url

def db_rows_to_dict (root_name, cur):
    column_names = cur.description
    rows = cur.fetchall()

    d = {root_name: []}
   
    if len(rows) >= 1 and len(rows[0]) > 1:
        d[root_name] = [] 
        for row in rows:
            rowDict = {}
            for i in range(len(column_names)):
                rowDict[column_names[i][0]] = row[i]
                
            d[root_name].append(rowDict)
    elif len(rows) == 1 and len(rows[0]) == 1:
        d[root_name] = {column_names[0][0]: rows[0]}
        
    return d

class DataGuy (object):

# error dicts look like:
# { status: "error", error_msg: "<blahblahblah" }

# DataGuy error handling:
# For commands that require a row to be returned (getseasonsummary, etc), but get no rows
# back from the DB, set an error
# 
# For commands that can have zero rows returned, this is not an error; instead, return a useful dict to the user
#
# For DB failures, return an error dict
#
    def __init__ (self, db_path):
        self.db_path = db_path

        #print >>sys.stderr, "db_path: %s" % (db_path)
        self.dbcon = sqlite3.connect(db_path, detect_types=sqlite3.PARSE_DECLTYPES|sqlite3.PARSE_COLNAMES)      

    # decorator example from http://wiki.python.org/moin/PythonDecoratorLibrary
    def simple_decorator(decorator):
       def new_decorator(f):
           g = decorator(f)
           g.__name__ = f.__name__
           g.__doc__ = f.__doc__
           g.__dict__.update(f.__dict__)
           return g
       # Now a few lines needed to make simple_decorator itself
       # be a well-behaved decorator.
       new_decorator.__name__ = decorator.__name__
       new_decorator.__doc__ = decorator.__doc__
       new_decorator.__dict__.update(decorator.__dict__)
       return new_decorator

    @simple_decorator
    def db_error_handler(func):
        def handle_db_error(*args, **kwargs):
            try:
                return func(*args, **kwargs)
            except sqlite3.Error, e:
                logging.error("error handling DB query: %s" % (traceback.print_exc()))
                return {"status": "error", "error_msg": e}
        return handle_db_error

    
    @db_error_handler
    def login (self, login_credential, password):

        result = {'status' : "error", "error_msg": "Authentication failure."}

        if password == None or password == '':
            result = {'status' : "error", "error_msg": "Authentication failure."}
            return result
        
        cur = self.dbcon.cursor()

        cur.execute("SELECT id, name, emailAddress FROM players WHERE emailAddress = ? and password = ?", 
                    (login_credential, password))

        try:
            userID, name, email_address = cur.fetchone()
            result = {'status' : "ok", 'email_address' : email_address, 'id' : userID, 'name' : name }
        except Exception, e:
            logging.error("error: %s" % (e))
            result = {'status' : "error", "error_msg": "Authentication failure."}            

        cur.close()

        return result

    @db_error_handler
    def add_player (self, name, email, password):
        
        logging.info("adding user %s" % (email))

        cur = self.dbcon.cursor()

        fields = ['emailAddress', 'name', 'password']
        values = [email, name, password]


        cur.execute("INSERT INTO players (%s) VALUES (%s)" % (','.join(fields),
                                                            ','.join(["?"] * len(fields))),
                    tuple(values))

            
        self.dbcon.commit()

        cur.execute('SELECT last_insert_rowid()')

        user_id = cur.fetchone()[0]

        cur.close()
        
        return {"status": "ok", 'id': user_id}
