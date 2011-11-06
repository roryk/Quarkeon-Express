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
- (void)startSampleGame;
- (id)initWithGameState:(GameState *)gs;

- (void)addPlayer:(int)startingUranium playerName:(NSString *)playerName;
- (NSArray *)loadBackgrounds;

@end