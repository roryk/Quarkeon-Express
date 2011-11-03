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


@interface GameCreator : NSObject {
    NSMutableArray *cells;
    GameState *gamestate;
}

@property (nonatomic, retain) NSMutableArray *cells;
@property (nonatomic, retain) GameState *gamestate;

- (NSMutableArray *)loadPlanets;
- (NSMutableArray *)loadPlist:(NSString *)fileName rootKey:(NSString *)rootKey;
- (void)makeRandomMap:(int)x y:(int)y max_planets:(int)max_planets;
- (void)startSampleGame;

@end