//
//  GameCreator.h
//  Quarkeon Express
//
//  Created by Rory Kirchner on 11/2/11.
//  Copyright 2011 MIT. All rights reserved.
//

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