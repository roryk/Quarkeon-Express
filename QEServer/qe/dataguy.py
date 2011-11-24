#!/usr/bin/env python


import logging

import sqlite3


import traceback
import random

import urlparse



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

        logging.info(login_credential + " " + password)
        try:
            userID, name, email_address = cur.fetchone()
            logging.info(str(userID) + " " + name + " " + email_address)
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


    @db_error_handler
    def init_new_db(self):
    # this is simply to help us get a big corpus of planets
    # if init db is called
    # we should move the image names into the DB, rather than having this as a list
        planet_images = [ 
                        'Arid World.jpg',
                        'Caldonia.jpg',
                        'Cold World.jpg',
                        'Dead World.jpg',
                        'Drye.jpg',
                        'Global Warming.jpg',
                        'High Winds.jpg',
                        'Ice Planet.jpg',
                        'Mostly Harmless.jpg',
                        'Nu Earth.jpg',
                        'Pyrobora.jpg',
                        'Small Gas Giant.jpg',
                        'Waterless World.jpg']
        planet_names = [
                        'Burn', 'Earth', 'Mars', 'New Earth', 'New Mars',
                        'New Mercury', 'New Jupiter', 'New Saturn', 'New Pluto', 'New Venus', 
                        'New Chiba', 'Ashpool', 'Germany', 'Merica', 'Cellulon', 
                        'Ertria', 'Goulton', 'Myria', 'Odin', 'Thesus',
                        'Appera', 'Pathi', 'Orgon', 'Quell', 'Bob', 
                        'Franliz', 'Ecaz', 'Oppoero', 'Worl', 'Solo', 
                        'Anakiin', 'Sophus', 'Lucien', 'Ciaus', 'Pyron',
                        'Losaoz', 'Syyz', 'Oiish', 'Posque', 'Rance',
                        'Celand', 'Anada', 'Apan', 'Hina', 'Pycon', 
                        'Hilee', 'Razil', 'Zelean', 'Papau', 'Uba'
                        ]



        cur = self.dbcon.cursor()

        cur.execute("DELETE FROM PLANETS")
        cur.execute("DELETE FROM PLAYERS")

        for name in planet_names:
            cur.execute("INSERT INTO planets (name, picture) VALUES (?, ?)", 
                    (name, planet_images[random.randint(0, len(planet_images) - 1)]))

        self.dbcon.commit()

        # setup some default users
        cur.execute("INSERT INTO players (name, emailAddress, password) VALUES ('adam', 'adamf@csh.rit.edu', 'foo')")
        cur.execute("INSERT INTO players (name, emailAddress, password) VALUES ('rory', 'roryk@mit.edu', 'foo')")
        cur.execute("INSERT INTO players (name, emailAddress, password) VALUES ('sean', 'seanth@gmail.com', 'foo')")

        self.dbcon.commit()

        cur.close()


    
    @db_error_handler
    def get_planets(self, count=0):
        cur = self.dbcon.cursor()
        limit = ""
        if count != 0:
            limit = "LIMIT " + str(count)

        cur.execute("SELECT * FROM PLANETS " + limit)
       
        planets = db_rows_to_dict('planets', cur)
        cur.close()

        planets['status'] = 'ok'     

        return planets
        
    @db_error_handler
    def get_game(self, game_id):
        cur = self.dbcon.cursor()
        cur.execute("SELECT * FROM game WHERE id=?", (game_id,))
        result = {}
        
        result['game'] = db_rows_to_dict('game', cur)
        result['id'] = game_id

        cur.execute("SELECT * FROM map WHERE game=?", (game_id,))
        result['map'] = db_rows_to_dict('map', cur)

        cur.execute("SELECT * FROM player_in_game WHERE game=?", (game_id,))
        result['players'] = db_rows_to_dict('players', cur)
        
        cur.execute("SELECT * FROM planet_in_game WHERE game=?", (game_id,))
        result['planets'] = db_rows_to_dict('planets', cur)

        result['status'] = 'ok'

        return result
        

    @db_error_handler
    def create_game(self, players, starting_uranium, width, height, planet_percentage, mean_uranium, mean_planet_life):
        cur = self.dbcon.cursor()

        logging.info(players)

        cur.execute("INSERT INTO game (players_in_game, whose_turn, num_planets, map, last_turn) VALUES (?, ?, ?, ?, ?)",
                        (len(players), 0, 0, 0, 0))

        self.dbcon.commit()

        cur.execute('SELECT last_insert_rowid()')

        game_id = cur.fetchone()[0]

        player_ids = []
        
        for player in players:
            cur.execute("SELECT id FROM players WHERE emailAddress = ?", (player,))

            player_id = cur.fetchone()[0]
            player_ids.append(player_id)

            cur.execute("INSERT INTO player_in_game (uranium, player, xLocation, yLocation, game) VALUES (?, ?, ?, ?, ?)", 
                            (starting_uranium, player_id, random.randint(1, width), random.randint(1, height), game_id))

       
        self.dbcon.commit()

        new_map = self.create_map (game_id, width, height, planet_percentage, mean_uranium, mean_planet_life) 

        whose_turn = random.choice(player_ids)

        cur.execute("UPDATE game SET whose_turn=?, num_planets=?, map=? WHERE id=?", 
                       (whose_turn, new_map['num_planets'], new_map['map_id'], game_id)) 

        self.dbcon.commit()

        return self.get_game(game_id)



    @db_error_handler
    def create_map(self, game_id, width=100, height=100, planet_percentage=40, mean_uranium=200, mean_planet_life=100):
        planets = self.get_planets()['planets']
        num_planets = len(planets)
        cur = self.dbcon.cursor()


        cur.execute("INSERT INTO map (game, width, height) VALUES (?, ?, ?)", 
            (game_id, width, height));

        self.dbcon.commit()

        cur.execute('SELECT last_insert_rowid()')

        map_id = cur.fetchone()[0]

        random.shuffle(planets)

        # each planet has some total uranium that is on the normal curve of the mean_uranium
        # earn_rate is total_uranium divided by mean_lifetime
        # cost is related to the total, plus/minus some fudge
        #

        for x in range(0, width):
            for y in range(0, height):
                if random.random() <= (planet_percentage * 0.01):

                    planet = planets.pop()

                    # XXX replace 3 with a better value
                    total_uranium = int(random.normalvariate(mean_uranium, mean_uranium/3)) + 1
                    earn_rate = int(total_uranium / random.normalvariate(mean_planet_life, mean_planet_life/3)) + 1
                    logging.info("putting planet at " + str(x) + ", " + str(y))

                    cost = earn_rate * mean_planet_life # XXX also improve this.
                    # XX and the id

                    cur.execute("INSERT INTO planet_in_game (name, picture, cost, earn_rate, total_uranium, game, map, xLocation, yLocation) " + 
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", (planet["name"], planet["picture"], cost, earn_rate, total_uranium, game_id, map_id, x, y));
                   
        self.dbcon.commit() 
        cur.execute("SELECT * FROM planet_in_game where map = ? and game = ?", (map_id, game_id))

        new_map = db_rows_to_dict('map', cur)
        cur.close()

        num_planets = abs(len(planets) - num_planets)

        new_map['num_planets'] = num_planets
        new_map['width'] = width
        new_map['height'] = height
        new_map['map_id'] = map_id
        new_map['status'] = 'ok'     

        logging.info(new_map)

        return new_map
