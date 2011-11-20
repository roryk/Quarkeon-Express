//
//  Player.h
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
#import "Cell.h"

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
