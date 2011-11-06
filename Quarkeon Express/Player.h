//
//  Player.h
//  Quarkeon Express
//
//  Created by Rory Kirchner on 10/21/11.
//  Copyright 2011 MIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cell.h"
#import "Quarkeon_ExpressAppDelegate.h"

@class Spaceship;
@class Planet;
@class Quarkeon_ExpressAppDelegate;

@interface Player : NSObject {
    Quarkeon_ExpressAppDelegate *appDelegate;
    NSString *name;
    Cell *currLocation;
    int xLocation;
    int yLocation;
    UIImage *picture;
    Spaceship *ship;
    int clones;
    int bucks;
    int uranium;
    int planetsOwned;
}

@property (readwrite, assign) int planetsOwned;
@property (readwrite, assign) int xLocation;
@property (readwrite, assign) int yLocation;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) UIImage *picture;
@property (readwrite, retain) Spaceship *ship;
@property (readwrite, retain) Cell *currLocation;

@property (readwrite, assign) int clones;
@property (readwrite, assign) int bucks;
@property (readwrite, assign) int uranium;

- (void)startTurn;
- (void)endTurn;
- (bool)buyCurrPlanet;
- (bool)canBuyCurrPlanet;
- (bool)canMoveInDirection:(NSString *)dir;
- (void)movePlayerInDirection:(NSString *)dir;

@end
