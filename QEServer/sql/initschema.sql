CREATE TABLE IF NOT EXISTS GAME (
        id INTEGER PRIMARY KEY,
        players_in_game INTEGER NOT NULL,
        whose_turn INTEGER NOT NULL,
        num_planets INTEGER NOT NULL,
        last_turn INTEGER NOT NULL
	);

CREATE TABLE IF NOT EXISTS PLAYER_IN_GAME (
        id INTEGER PRIMARY KEY,
        uranium INTEGER NOT NULL,
        player INTEGER NOT NULL,
        game INTEGER NOT NULL
    );

CREATE TABLE IF NOT EXISTS PLANET_IN_GAME (
        id INTEGER PRIMARY KEY,
        cost INTEGER NOT NULL,
        earn_rate INTEGER NOT NULL,
        total_uranium INTEGER NOT NULL,
        game INTEGER NOT NULL,
        owner INTEGER
    );

CREATE TABLE IF NOT EXISTS PLAYERS (
        id INTEGER PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        emailAddress VARCHAR(255) UNIQUE NOT NULL,
        password VARCHAR(255)
    );
    
CREATE TABLE IF NOT EXISTS PLANETS (
        id INTEGER PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        picture VARCHAR(255) NOT NULL,
        description VARCHAR(255) NOT NULL,
        cost INTEGER NOT NULL,
        earn_rate INTEGER NOT NULL,
        starting_uranium INTEGER NOT NULL
    );

INSERT INTO players (name, emailAddress, password) VALUES ('adam', 'adamf@csh.rit.edu', 'foo');
INSERT INTO players (name, emailAddress, password) VALUES ('rory', 'roryk@mit.edu', 'foo');
INSERT INTO players (name, emailAddress, password) VALUES ('sean', 'seanth@gmail.com', 'foo');
