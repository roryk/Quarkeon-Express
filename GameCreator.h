//
//  GameCreator.h
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
#import "Gamestate.h"
#import "Planet.h"
#import "MapGenerator.h"
#import "Cell.h"
#import "Player.h"
#import "Queue.h"
#import "AI.h"

@class GameState;


@interface GameCreator : NSObject {
    NSMutableArray *cells;
    GameState *gameState;
    
    // "size" in this case is the value used for the width & height of the grid
    // eg, largeMapSize = 100 would mean you get a width of 100 cells and height
    // of 100 cells.
    
    int largeMapSize;
    int smallMapSize;
    int mediumMapSize; 
    int largeMapMaxPlanets;
    int mediumMapMaxPlanets;
    int smallMapMaxPlanets;
    int defaultUranium; 
    MapGenerator *mg;

}

/* 
 params = {'players': tornado.escape.json_encode(players), 
 'map_width': 5,
 'map_height': 5,
 'planet_percentage': 20,
 'mean_uranium': 100,
 'mean_planet_lifetime': 100,
 'starting_uranium': 4000
 }
 */

// multiplayer properties
@property (readwrite, assign) int largeMapMeanPlanetLifetime;
@property (readwrite, assign) int mediumMapMeanPlanetLifetime;
@property (readwrite, assign) int smallMapMeanPlanetLifetime;

@property (readwrite, assign) int largeMapMeanPlanetTotalU;
@property (readwrite, assign) int mediumMapMeanPlanetTotalU;
@property (readwrite, assign) int smallMapMeanPlanetTotalU;

@property (readwrite, assign) int largeMapStartingU;
@property (readwrite, assign) int mediumMapStartingU;
@property (readwrite, assign) int smallMapStartingU;

@property (readwrite, assign) int largeMapPlanetPercentage;
@property (readwrite, assign) int mediumMapPlanetPercentage;
@property (readwrite, assign) int smallMapPlanetPercentage;

// single player properties

@property (readwrite, assign) int largeMapSize;
@property (readwrite, assign) int smallMapSize;
@property (readwrite, assign) int mediumMapSize;

@property (readwrite, assign) int largeMapMaxPlanets;
@property (readwrite, assign) int smallMapMaxPlanets;
@property (readwrite, assign) int mediumMapMaxPlanets;

@property (readwrite, assign) int defaultUranium;


@property (nonatomic, retain) NSMutableArray *cells;
@property (nonatomic, retain) GameState *gameState;
@property (nonatomic, retain) MapGenerator *mg;


- (NSMutableArray *)loadPlanets;
- (NSMutableArray *)loadPlist:(NSString *)fileName rootKey:(NSString *)rootKey;

- (void)makeRandomMap:(int)x y:(int)y max_planets:(int)max_planets;
- (void)makeFixedMapWithPlanets:(int)width height:(int)height planets:(NSMutableArray *)planets;

- (void)startSampleGame;
- (id)initWithGameState:(GameState *)gs;

- (void)addPlayer:(int)startingUranium playerName:(NSString *)playerName isAI:(bool)isAI;
- (void)addMultiplayerPlayer:(NSString *)emailAddress;

- (NSArray *)loadBackgrounds;

@end