#!/usr/bin/env python


import logging

import sqlite3


import traceback
import random

import urlparse

import uuid



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
                        'Hilee', 'Razil', 'Zelean', 'Papau', 'Uba',
                        'Mensae III', 'Uruk', 'Galli III', 'Ahemait II', 'Mkale',
                        'Hofa', 'Hargi VI', 'Svati VII', 'Tian-Mu', 'Lifthrasir', 'Peng-Lai-Shan',
                        'Freyr', 'Babbar', 'Tranxu Dbaale', 'Maenali VI', 'Endiku', 'Slombi', 'Liluri',
                        'Deino V', 'Ronii IV', 'Li-Nezha Prime', 'Mudi III',
                        'Serket', 'Dale Byoti', 'Mensae II', 'Lei-Zu', 'Dziewanna',
                        'Kvorti', 'Hurquij IV', 'He-Xian-Gu V', 'Magni', 'Sagittae III',
                        'Qetesh', '3460 Wei Xiu II', 'New Phaeton', 'Almar', '9453 Gui Xiu V',
                        'Nemesis II', 'Goni C-Yeectroilph', '6527 Mali VI', 'Ahemait', 'Liara',
                        'New Babylon', 'Mintau VI', 'Omen Shawin', 'Kulla', 'New Thyoph', 'Smei-Gorynich III',
                        'Metha I-Lori', 'Song-Jiang VI', 'Baja', 'New Laurentia', 'A-Vorte',
                        'New Vulcan', 'New Mars', 'Xu Xiu VII', 'Velorum IV', 'New Triton', 'Berith',
                        'Laukamat III', 'He-Xian-Gu IV', 'New Angeles', 'Lachesis', 'New Oberon',
                        'V-Jiro', 'S-Brani', 'Gothmog', 'I-Rani', 'Xi-He Prime', 'Tilion',
                        'Elyon', 'Hoggi IV', 'Feanor', 'Krani', 'Hadi', 'Dobrynya', 'Yarikh',
                        'Trani II', 'New Gaia', 'R-Gridu', 'Jyeshtha VII', 'Kyuli', 'Arietis III',
                        'New Terra', 'Ceti III', 'H-Vilga', 'Hohnir', 'Reticuli III', 'Tencta', 'Hippolyta IV'
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
        cur.execute("INSERT INTO players (name, emailAddress, password) VALUES ('jessica', 'jessica.mckellar@gmail.com', 'foo')")

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
    def get_my_games(self, current_user):
        cur = self.dbcon.cursor()

        cur.execute("SELECT name, id, players_in_game FROM game WHERE id IN " + 
                "(SELECT game FROM player_in_game WHERE player=?) AND game_over = 0", (current_user["id"],))

        result = db_rows_to_dict('games', cur)
        result["status"] = 'ok'

        return result

    @db_error_handler
    def get_status(self, game_id, current_user):
        cur = self.dbcon.cursor()

        inGame = self.check_in_game(game_id, current_user)
        if inGame["status"] != "ok":
            return inGame

        cur.execute("SELECT whose_turn FROM game WHERE id=? AND game_over = 0", (game_id,))

        # check winning here?

        whose_turn = cur.fetchone()[0]

        cur.execute("SELECT emailAddress, name, id FROM players WHERE id=?", (whose_turn,))

        active_player_details = db_rows_to_dict('whose_turn', cur)['whose_turn'][0]

        cur.execute("SELECT * FROM player_in_game WHERE player=? AND game=?", (current_user["id"], game_id))

        my_state = db_rows_to_dict('my_state', cur)['my_state'][0]

        cur.execute("SELECT * from planet_in_game WHERE xLocation=? AND yLocation=? AND game=?", 
            (my_state["xLocation"], my_state["yLocation"], game_id))

        planet = db_rows_to_dict("planet", cur)['planet']
        if planet:
            planet = planet[0]

        if whose_turn == current_user["id"]:
            return {"status": "ok", "game_id": game_id, "whose_turn": active_player_details, 
                    "my_turn": True, "my_state": my_state, "planet": planet}

        return {"status": "ok", "game_id": game_id, "whose_turn": active_player_details, 
                "my_turn": False, "my_state": my_state, "planet": planet}

    @db_error_handler
    def get_players_in_game(self, game_id, current_user):
        cur = self.dbcon.cursor()

        inGame = self.check_in_game(game_id, current_user)
        if inGame["status"] != "ok":
            return inGame

        cur.execute("SELECT * FROM player_in_game WHERE game=? AND player=?", 
                (game_id, current_user["id"]))

        current_player_data = db_rows_to_dict('me', cur)['me'][0]


        cur.execute("SELECT player FROM player_in_game WHERE game=?", 
                (game_id,))

        player_ids = cur.fetchall()

        result = {}
        result["players"] = [] 
        for player_id, in player_ids:
            cur.execute("SELECT emailAddress, name FROM players WHERE id=?", (player_id,))
            emailAddress, name = cur.fetchone()

            playerDict = { "player": player_id, "emailAddress": emailAddress, "name": name}

            if playerDict["player"] == current_user["id"]:

                for key, value in current_player_data.iteritems():
                    playerDict[key] = value

            result["players"].append(playerDict)

        return result
            

    @db_error_handler
    def buy_planet(self, game_id, planet_id, current_user):
        cur = self.dbcon.cursor()

        # check that the current_user is a player in the game.
        inGame = self.check_in_game(game_id, current_user)
        if inGame["status"] != "ok":
            return inGame

        # check that it is the current users' turn
        isTurn = self.check_my_turn(game_id, current_user)
        if isTurn["status"] != "ok":
            return isTurn

        cur.execute("SELECT xLocation, yLocation, cost, owner FROM planet_in_game WHERE id=? and game=?", 
                (planet_id, game_id))

        planet = db_rows_to_dict('planet', cur)['planet'][0]

        if planet["owner"] == current_user["id"]:
            return {"status": "error", "error_msg": "You already own this planet"}

        # check that the current user has the funds needed
        hasMoney = self.check_has_funds(game_id, planet["cost"], current_user)
        if hasMoney["status"] != "ok":
            return hasMoney

        # check that the current and the planet have the same location
        cur.execute("SELECT xLocation, yLocation, uranium FROM player_in_game WHERE player=? and game=?", 
                (current_user["id"], game_id))

        player = db_rows_to_dict('player', cur)['player'][0]

        if (player["xLocation"] == planet["xLocation"] and 
            player["yLocation"] == planet["yLocation"] and 
            player["uranium"] >= planet["cost"]):

            new_uranium = player["uranium"] - planet["cost"]
            new_cost = int(planet["cost"] * 1.5) # XXX we should make this factor some value in the DB

            cur.execute("UPDATE planet_in_game SET owner=?, cost=? WHERE id=? AND game=?", (current_user["id"], new_cost, planet_id, game_id))
            cur.execute("UPDATE player_in_game SET uranium=? WHERE player=? AND game=?", (new_uranium, current_user["id"], game_id))

            self.dbcon.commit()

            return {"status": "ok", "bought": True, "uranium": new_uranium, "cost": new_cost}
        

        return {"status": "ok", "bought": False}

    @db_error_handler
    def move_player(self, game_id, new_x, new_y, cost_to_move, current_user):
        cur = self.dbcon.cursor()

        # check that the current_user is a player in the game.
        inGame = self.check_in_game(game_id, current_user)
        if inGame["status"] != "ok":
            return inGame

        # check that it is the current users' turn
        isTurn = self.check_my_turn(game_id, current_user)
        if isTurn["status"] != "ok":
            return isTurn

        # check that the current user has the funds needed
        hasMoney = self.check_has_funds(game_id, cost_to_move, current_user)
        if hasMoney["status"] != "ok":
            return hasMoney

        cur.execute("SELECT xLocation, yLocation, uranium FROM player_in_game WHERE player=? and game=?", 
                (current_user["id"], game_id))

        player = db_rows_to_dict('player', cur)['player'][0]

        # check that the new location is one x xor one y away from the current location
        if abs(player["xLocation"] - new_x) + abs(player["yLocation"] - new_y) != 1:
            return {"status": "error", "error_msg": "Attempted illegal move"}


        # update the player
        new_uranium = player["uranium"] - cost_to_move
        cur.execute("UPDATE player_in_game SET uranium=?, xLocation=?, yLocation=? WHERE player=? AND game=?", 
                (new_uranium, new_x, new_y, current_user["id"], game_id))

        self.dbcon.commit()

        # return planet details if they are here
        cur.execute("SELECT * FROM planet_in_game WHERE xLocation=? AND yLocation=? AND game=?", (new_x, new_y, game_id))
        planet_at_cell = db_rows_to_dict('planet', cur)['planet']
        if planet_at_cell != []:
            planet_at_cell = planet_at_cell[0]

        return {"status": "ok", "xLocation": new_x, "yLocation": new_y, "uranium": new_uranium, "planet": planet_at_cell}


    @db_error_handler
    def start_turn(self, game_id, current_user):
        cur = self.dbcon.cursor()

        # check that the current_user is a player in the game.
        inGame = self.check_in_game(game_id, current_user)
        if inGame["status"] != "ok":
            return inGame

        # check that it is the current users' turn
        isTurn = self.check_my_turn(game_id, current_user)
        if isTurn["status"] != "ok":
            return isTurn


        cur.execute("SELECT num_planets FROM game WHERE id=?", (game_id,))

        num_planets, = cur.fetchone()

        cur.execute("SELECT * from planet_in_game WHERE owner=? and game=?", (current_user["id"], game_id))

        owned_planets = db_rows_to_dict('planets', cur)['planets']

        # check to see if you won.
        # XXX the 50% measure here should be a config parameter in create game...
        if len(owned_planets) > int(num_planets / 2):
            cur.execute("UPDATE game SET game_over=1 WHERE id=?", (game_id,))
            self.dbcon.commit()
            return { "status": "ok", "won_game": True }

        # update the uranium based on owned planet earn rate

        earned_uranium = 0 
        for planet in owned_planets:

            if planet["earn_rate"] > planet["total_uranium"]:
                planet["earn_rate"] = planet["total_uranium"]

            earned_uranium = earned_uranium + planet["earn_rate"]

            new_total_u = planet["total_uranium"] - planet["earn_rate"]

            # XXX we should set a flag indicating the planet is dead if total_u == 0
            # decrement the total uranium in a planet
            cur.execute("UPDATE planet_in_game SET total_uranium=? WHERE id=? AND game=?", 
                    (new_total_u, planet["id"], game_id))

            self.dbcon.commit()

        cur.execute("SELECT uranium FROM player_in_game WHERE player=? AND game=?", (current_user["id"], game_id))

        current_u, = cur.fetchone()

        new_u = current_u + earned_uranium

        cur.execute("UPDATE player_in_game SET uranium=? WHERE player=? AND game=?", (new_u, current_user["id"], game_id))

        return {"status": "ok", "won_game": False, "new_u": new_u}


    @db_error_handler
    def end_turn(self, game_id, current_user):
        cur = self.dbcon.cursor()

        # check that the current_user is a player in the game.
        inGame = self.check_in_game(game_id, current_user)
        if inGame["status"] != "ok":
            return inGame

        # check that it is the current users' turn
        isTurn = self.check_my_turn(game_id, current_user)
        if isTurn["status"] != "ok":
            return isTurn


        cur.execute("SELECT round FROM player_in_game WHERE player=? AND game=?", (current_user["id"], game_id))

        cur_round, = cur.fetchone()

        new_round = cur_round + 1
        # increment this player's round counter
        cur.execute("UPDATE player_in_game SET round=? WHERE player=? AND game=?", (new_round, current_user["id"], game_id))
        self.dbcon.commit()

        # get a player whose round counter is the same as the old round
        cur.execute("SELECT player FROM player_in_game WHERE game=? AND round=?", 
                (game_id, cur_round))

        possible_players = cur.fetchall()

        if possible_players != []:
            random.shuffle(possible_players)
            whose_turn, = possible_players[0]
        else:
            cur.execute("SELECT player FROM player_in_game WHERE game=? AND round=?", 
                    (game_id, new_round))

            possible_players = cur.fetchall()
            random.shuffle(possible_players)
            whose_turn, = possible_players[0]


        cur.execute("UPDATE game SET whose_turn=? WHERE id=?", (whose_turn, game_id))
        self.dbcon.commit()

        return {"status": "ok", "whose_turn": whose_turn}


    @db_error_handler
    def get_game(self, game_id, current_user):
        cur = self.dbcon.cursor()

        # check that the current_user is a player in the game.
        inGame = self.check_in_game(game_id, current_user)
        if inGame["status"] != "ok":
            return inGame

        cur.execute("SELECT * FROM game WHERE id=?", (game_id,))
        result = {}
        
        result['game'] = db_rows_to_dict('game', cur)['game'][0]
        result['id'] = game_id


        cur.execute("SELECT * FROM map WHERE game=?", (game_id,))
        result['map'] = db_rows_to_dict('map', cur)['map'][0]

        result['players'] = self.get_players_in_game(game_id, current_user)['players']


        cur.execute("SELECT * FROM planet_in_game WHERE game=?", (game_id,))
        result['planets'] = db_rows_to_dict('planets', cur)['planets']

        result['status'] = 'ok'

        return result
        

    @db_error_handler
    def create_game(self, players, starting_uranium, width, height, planet_percentage, mean_uranium, mean_planet_life, current_user):
        cur = self.dbcon.cursor()


        game_name = str(uuid.uuid4()).split('-')[0]

        cur.execute("INSERT INTO game (players_in_game, whose_turn, num_planets, map, last_turn, owner, name, game_over) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?)", (len(players), 0, 0, 0, 0, current_user["id"], game_name, 0))

        self.dbcon.commit()

        cur.execute('SELECT last_insert_rowid()')

        game_id = cur.fetchone()[0]

        player_ids = []


        # XXX what happens here if the player doesn't exist?
        # Should we just add them? 
        for player in players:
            cur.execute("SELECT id FROM players WHERE emailAddress = ?", (player,))

            player_id = cur.fetchone()[0]
            player_ids.append(player_id)

            cur.execute("INSERT INTO player_in_game (uranium, player, xLocation, yLocation, game, round) VALUES (?, ?, ?, ?, ?, ?)", 
                            (starting_uranium, player_id, random.randint(0, width-1), random.randint(0, height-1), game_id, 0))
            self.dbcon.commit()

       
        new_map = self.create_map (game_id, width, height, planet_percentage, mean_uranium, mean_planet_life) 

        whose_turn = random.choice(player_ids)

        cur.execute("UPDATE game SET whose_turn=?, num_planets=?, map=? WHERE id=?", 
                       (whose_turn, new_map['num_planets'], new_map['map_id'], game_id)) 

        self.dbcon.commit()



        return self.get_game(game_id, current_user)



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

        return new_map

    @db_error_handler
    def check_in_game(self, game_id, current_user):
        cur = self.dbcon.cursor()

        # check that the current_user is a player in the game.
        cur.execute("SELECT * FROM player_in_game WHERE game=? AND player=?", 
                (game_id, current_user["id"]))

        inGame = cur.fetchone()

        if inGame == None:
                return {"status": "error", "error_msg": "You are not in this game" }

        cur.close()
        return {"status": "ok"}

    @db_error_handler
    def check_my_turn(self, game_id, current_user):
        cur = self.dbcon.cursor()

        # check that it is the current users' turn
        cur.execute("SELECT whose_turn FROM game WHERE id=?", (game_id,))
        whose_turn, = cur.fetchone()

        if whose_turn != current_user["id"]:
            return {"status": "error", "error_msg": "It is not your turn" }

        cur.close()
        return {"status": "ok"}

    @db_error_handler
    def check_has_funds(self, game_id, cost, current_user):
        cur = self.dbcon.cursor()

        cur.execute("SELECT uranium FROM player_in_game WHERE player=? and game=?", 
                (current_user["id"], game_id))

        uranium, = cur.fetchone()

        if uranium < cost:
           return {"status": "error", "error_msg": "Insufficient funds"}

        return {"status": "ok"}

