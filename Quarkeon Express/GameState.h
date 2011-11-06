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
    NSMutableArray *cells;
    Cell *currCell;
    Player *currPlayer;
    NSMutableArray *players;
    NSMutableArray *turnQueue;
    int numPlayers;
    NSString *mapSize;
    
}
@property (readwrite, assign) int numPlayers;
@property (nonatomic, retain) NSString *mapSize;

@property (nonatomic, retain) Cell *currCell;
@property (nonatomic, retain) Player *currPlayer;
@property (nonatomic, retain) NSMutableArray *turnQueue;
@property (nonatomic, retain) NSMutableArray *cells;
@property (nonatomic, retain) NSMutableArray *planets;

@property (nonatomic, retain) NSMutableArray *players;

- (bool)buyCurrPlanet;
- (bool)canBuyCurrPlanet;
- (bool)didCurrentPlayerWin;
- (void)endTurn;
- (void)startTurn;
- (void)gameOverCleanup;
- (void)setupTurnOrder;
- (bool)canMove:(NSString *)dir;

@end