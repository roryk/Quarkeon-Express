//
//  Player.m
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

#import "Player.h"
#import "Planet.h"
#import "Quarkeon_ExpressAppDelegate.h"


@implementation Player

@synthesize name;
@synthesize xLocation, yLocation;
@synthesize picture;
@synthesize ship;
@synthesize clones, bucks, uranium;
@synthesize currLocation;
@synthesize planetsOwned;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        appDelegate = (Quarkeon_ExpressAppDelegate *)[[UIApplication sharedApplication] delegate];    
        self.currLocation = nil;
        self.name = nil;
        self.ship = nil;
        self.planetsOwned = 0;
    }
    
    return self;
}

-(void) startTurn {
}

-(void) endTurn {
}

- (bool)canBuyCurrPlanet
/**
 checks to see if the player can buy the planet at their current location
**/
{
    if(self.currLocation.planet == nil) {
        return false;
    }
    if (self.currLocation.planet.currentCost <= self.uranium) {
        return true;
    }
    return false;
    
}

- (bool)buyCurrPlanet   
{
    if(self.currLocation.planet == nil) {
        return false;
    }
    if ([self canBuyCurrPlanet]) {
        Planet *planet = self.currLocation.planet;
        if (planet.owner != nil) {
            planet.owner.planetsOwned = planet.owner.planetsOwned - 1;
        }
        self.uranium = self.uranium - planet.currentCost;
        planet.owner = self;
        planet.currentCost = planet.currentCost * 1.5;
        self.planetsOwned = self.planetsOwned + 1;
        
        return true;
    }
    
    return false;
}

- (bool)canMoveInDirection:(NSString *)dir {
    /**
     can the current player move in the direction 'dir'?
     **/
    return([self.currLocation hasLane:dir] && (self.uranium > 0));
}

- (void) movePlayerInDirection:(NSString *)dir {
    /**
     checks to see if a player can move in a direction. if so, subtracts the uranium from their cache
     and updates the current planet on the gamestate and the current planet on the player. 
     **/
    Cell *newcell = [self.currLocation.exits objectForKey:dir];
    if([self canMoveInDirection:dir]) {
        self.uranium -= 1;
        appDelegate.gameState.currCell = newcell;
        self.currLocation = newcell;
        [newcell.visitedBy addObject:self];
    }
}

@end
