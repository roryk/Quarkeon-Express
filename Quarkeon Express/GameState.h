//
//  GameState.h
//  Quarkeon Express
//
//  Created by Rory Kirchner on 10/21/11.
//  Copyright 2011 MIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"
@class Player;
@class Planet;
@class SpaceLane;
@class Game;

@interface GameState : NSObject {
    NSMutableArray *player;
    NSMutableArray *planets;
    /* 
     XXX adamf: right now we load all the games into this class, which is a broken abstraction.
     we should keep the available games separate from the state of the current game.
     */
    Planet *currPlanet;
    Planet *startPlanet;
    Planet *endPlanet;
    NSMutableArray *games;
    Game *currentGame; // the game we are playing.
    Player *currPlayer;
    NSMutableArray *players;
    NSMutableArray *turnQueue;
    
}

@property (readwrite, assign) Planet *currPlanet;
@property (readwrite, assign) Game *currentGame;
@property (readwrite, assign) Player *currPlayer;
@property (nonatomic, retain) NSMutableArray *turnQueue;

@property (nonatomic, retain) NSMutableArray *players;
@property (nonatomic, retain) NSMutableArray *planets;
@property (nonatomic, retain) NSMutableArray *games;



- (bool)loadPlanets;
- (bool)loadGames;
- (NSMutableArray *)loadPlist:(NSString *)fileName rootKey:(NSString *)rootKey;

- (void)addPlayer:(int)startingUranium playerName:(NSString *)playerName;
- (void)startGame:(Game *)game;
- (bool)buyCurrPlanet;
- (bool)canBuyCurrPlanet;
- (bool)didCurrentPlayerWin;
- (void)endTurn;
- (void)startTurn;
- (void)gameOverCleanup;

@end