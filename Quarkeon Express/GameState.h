//
//  GameState.h
//  Quarkeon Express
//
//   Copyright 2011 Rory Kirchner
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

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

@property (readwrite, assign) bool isMultiplayer;

@property (readwrite, assign) int numPlayers;
@property (nonatomic, retain) NSString *mapSize;

@property (nonatomic, retain) NSString *myEmailAddress;
@property (readwrite, assign) int myUserID;



@property (nonatomic, retain) Cell *currCell;
@property (nonatomic, retain) Player *currPlayer;
@property (nonatomic, retain) NSMutableArray *turnQueue;
@property (nonatomic, retain) NSMutableArray *cells;
@property (nonatomic, retain) NSMutableArray *planets;

@property (nonatomic, retain) NSMutableArray *players;

- (bool)didCurrentPlayerWin;
- (void)endTurn;
- (void)startTurn;
- (void)gameOverCleanup;
- (void)setupTurnOrder;
- (bool)canMove:(NSString *)dir;
-(void)setupTurn;

@end