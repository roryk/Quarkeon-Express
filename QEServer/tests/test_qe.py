#!/usr/bin/env python

import httplib
import urllib
import random
import optparse
import tornado.escape


class QEPlayer:

    def __init__(self, _host, _port):
        self.host = _host
        self.port = _port
        self.url = 'http://' + self.host + ':' + self.port
        self.xsrf = ""
        self.cookies = {}
        self.game_state = {}
        self.game_map = {}
        self.game_planets = []
        self.email = ""
        self.pid = ""
        self.myturn = False
        self.x = -1
        self.dir_x = 1
        self.dir_y = 1
        self.y = -1
        self.gid = ""
        self.turn = 0

    def do_get(self, path, qstring):
        headers = {"Content-type": "application/x-www-form-urlencoded","Accept": "text/plain"}
        headers["Cookie"] = self.cookies

        full_url = self.url + path 
        if qstring != '':
            full_url = full_url + '?' + qstring

        conn = httplib.HTTPConnection(self.host, self.port)
        conn.request("GET", full_url, "", headers)
        response = conn.getresponse()
        return response.read()

    def do_post(self, path, values):
        headers = {"Content-type": "application/x-www-form-urlencoded","Accept": "text/plain"}
        headers["Cookie"] = self.cookies
        values["_xsrf"] = self.xsrf
        params = urllib.urlencode(values)
        full_url = self.url + path
        conn = httplib.HTTPConnection(self.host, self.port)
        conn.request("POST", full_url, params, headers)
        response = conn.getresponse()

        if response.getheader('set-cookie'):
            self.cookies = response.getheader('set-cookie')
            print "Cookies: ", self.cookies

            name, value = self.cookies.split(';')[0].split('=')
            if name == '_xsrf':
                self.xsrf = value

        return response.read()


    def login(self, email, password):
        params = {'email_address': email, 'password': password}
        json = self.do_post("/api/login", params)
        player_data = tornado.escape.json_decode(json)
        self.pid = player_data["id"]
        self.email = player_data["email_address"]
        print "Login json:\n", json

    def creategame(self, players):
        params = {'players': tornado.escape.json_encode(players), 
                  'map_width': 5,
                  'map_height': 5,
                  'planet_percentage': 20,
                  'mean_uranium': 100,
                  'mean_planet_lifetime': 100,
                  'starting_uranium': 4000
                  }
        json = self.do_post("/api/creategame", params)
        game_data = tornado.escape.json_decode(json)
        self.game_state = game_data
        self.game_map = game_data["map"]
        self.game_planets = game_data["planets"]
        self.gid = game_data["id"]
        print self.game_map

    def getstatus(self):
        json = self.do_get("/api/getstatus", "game_id=" + str(self.gid))
        status = tornado.escape.json_decode(json)
        self.x = status["my_state"]["xLocation"]
        self.y = status["my_state"]["yLocation"]
        self.myturn = status["my_turn"]
        print "status json:\n", json
        return status["whose_turn"]["id"]

    def loadgame(self):
        json = self.do_get("/api/loadgame", "game_id=" + str(self.gid))
        game_data = tornado.escape.json_decode(json)
        self.game_state = game_data
        self.game_map = game_data["map"]
        self.game_planets = game_data["planets"]
        print "load game json:\n", json

    def getmygames(self):
        json = self.do_get("/api/getmygames",'')
        games = tornado.escape.json_decode(json)
        self.gid = games["games"][0]["id"]
        print "get my games json:\n", json

    def startturn(self):
        params = {'game_id': self.gid}
        json = self.do_post("/api/startturn", params)
        turn_state = tornado.escape.json_decode(json)
        print "start turn json:\n", json
        return turn_state["won_game"]

    def endturn(self):
        params = {'game_id': self.gid}
        json = self.do_post("/api/endturn", params)
        turn_state = tornado.escape.json_decode(json)
        print turn_state

    def move(self):
        params = {'game_id': self.gid}
        if self.x == self.game_map["width"]:
            self.dir_x = -1
        if self.y == self.game_map["height"]:
            self.dir_y = -1
        if self.x == 0:
            self.dir_x = 1
        if self.y == 0:
            self.dir_y = 1

        if random.randint(1,2) == 1:
            params['new_x'] = self.x + self.dir_x
            params['new_y'] = self.y
        else:
            params['new_x'] = self.x 
            params['new_y'] = self.y + self.dir_y


        json = self.do_post("/api/move", params)
        move_state = tornado.escape.json_decode(json)

        self.x = params['new_x']
        self.y = params['new_y']

        if move_state["status"] == "ok" and move_state["planet"] != []:
            return move_state["planet"]["id"]

        return None

        
    def buyplanet(self, planetid):
        params = {'game_id': self.gid, 'planet_id': planetid}
        json = self.do_post("/api/buyplanet", params)
        buy_state = tornado.escape.json_decode(json)
        print buy_state

if __name__ == '__main__': 

    opts = optparse.OptionParser()
    opts.add_option("--host", "-t", help="host")
    opts.add_option("--port", "-p", help="port")
    options, arguments = opts.parse_args()

    players = []
    players.append(QEPlayer(options.host, options.port))
    players.append(QEPlayer(options.host, options.port))
    players.append(QEPlayer(options.host, options.port))
    players.append(QEPlayer(options.host, options.port))
    players[0].login('adamf@csh.rit.edu', 'foo')
    players[1].login('roryk@mit.edu', 'foo')
    players[2].login('seanth@gmail.com', 'foo')
    players[3].login('jessica.mckellar@gmail.com', 'foo')

    emails = []
    for player in players:
        emails.append(player.email)

    players[0].creategame(emails)

    for player in players:
        player.getmygames()
        player.loadgame()

    won_game = False
    turn_count = 0

    whose_turn = players[0].getstatus()

    while not won_game and turn_count < 400:
        turn_count = turn_count + 1
        print turn_count
        played = 0
        while played < len(players):
            for player in players: 
                if player.pid == whose_turn:
                    won_game = player.startturn()
                    if won_game:
                        print "We have a winner!", player.pid
                        exit(1)

                    has_planet = player.move()
                    move_count = 0
                    while not has_planet and move_count < 10:
                        move_count = move_count + 1
                        has_planet = player.move()

                    if move_count < 10:
                        player.buyplanet(has_planet)

                    player.endturn()
                    whose_turn = player.getstatus()
                    played = played + 1
                    break

