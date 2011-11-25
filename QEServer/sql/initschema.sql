CREATE TABLE IF NOT EXISTS GAME (
        id INTEGER PRIMARY KEY,
        players_in_game INTEGER NOT NULL,
        whose_turn INTEGER NOT NULL,
        num_planets INTEGER NOT NULL,
        map INTEGER NOT NULL,
        last_turn INTEGER NOT NULL,
        owner INTEGER NOT NULL,
        game_over INTEGER NOT NULL,
        name VARCHAR(255) NOT NULL
	);

CREATE TABLE IF NOT EXISTS PLAYER_IN_GAME (
        id INTEGER PRIMARY KEY,
        uranium INTEGER NOT NULL,
        player INTEGER NOT NULL,
        yLocation INTEGER NOT NULL,
        xLocation INTEGER NOT NULL,
        game INTEGER NOT NULL
    );

CREATE TABLE IF NOT EXISTS PLANET_IN_GAME (
        id INTEGER PRIMARY KEY,
        cost INTEGER NOT NULL,
        earn_rate INTEGER NOT NULL,
        total_uranium INTEGER NOT NULL,
        game INTEGER NOT NULL,
        map INTEGER NOT NULL,
        owner INTEGER,
        xLocation INTEGER NOT NULL,
        yLocation INTEGER NOT NULL,
        name VARCHAR(255) NOT NULL,
        picture VARCHAR(255) NOT NULL
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
        picture VARCHAR(255) NOT NULL
    );

CREATE TABLE IF NOT EXISTS MAP (
        id INTEGER PRIMARY KEY,
        game INTEGER NOT NULL,
        width INTEGER NOT NULL,
        height INTEGER NOT NULL
    );
