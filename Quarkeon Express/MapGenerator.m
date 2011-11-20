    //
//  MapGenerator.m
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

#import "MapGenerator.h"
#import "assert.h"
#import "Cell.h"
#import <stdlib.h>
#import "Planet.h"

@implementation MapGenerator

@synthesize cells;
@synthesize rows;
@synthesize cols;
@synthesize ncells;
@synthesize oppositeDirectionName;
@synthesize exitNames;
@synthesize loadedPlanets;
@synthesize usedPlanets;
@synthesize backgroundImages;

- (id)init
{
    self = [super init];
    if (self) {
        self.rows = 0;
        self.cols = 0;
        self.ncells = 0;
        self.cells = [NSMutableArray array];
        self.oppositeDirectionName = [NSMutableDictionary dictionary];
        self.exitNames = [NSMutableArray array];
        [self.oppositeDirectionName setObject:@"south" forKey:@"north"];
        [self.oppositeDirectionName setObject:@"north" forKey:@"south"];
        [self.oppositeDirectionName setObject:@"east" forKey:@"west"];
        [self.oppositeDirectionName setObject:@"west" forKey:@"east"];
        self.exitNames = [NSMutableArray arrayWithObjects:@"north", @"south", @"east", @"west", nil]; 
        self.loadedPlanets = [NSMutableArray array];
        self.usedPlanets = [NSMutableArray array];
        self.backgroundImages = [NSArray array];
    }    
    return self;
}

- (void) setSize:(int)x y:(int)y {
    assert((x > 0) && (y > 0));
    self.rows = x;
    self.cols = y;
    self.ncells = x * y;
}

- (void) initCells {
    int n;
    for(int i = 0; i < self.ncells; i++) {
        Cell *c = [[Cell alloc] init];
        n = arc4random() % [self.backgroundImages count];
        c.defaultpicture = [self.backgroundImages objectAtIndex:n];
        c.picture = c.defaultpicture;
        [self.cells addObject:c];
        [c release];
    }
}

- (NSMutableArray *) buildMap:(int) max_planets {
    int n = arc4random() % self.ncells;
    [self checkAndMove:n planets:0 max_planets:max_planets];
    return(self.cells);
}

- (bool) checkAndMove:(int) x planets:(int)planets max_planets:(int)max_planets {
    Planet *planet;
    if(planets >= max_planets) {
        return true;
    }
    Cell *cell = [self.cells objectAtIndex:x];
    cell.ongrid = true;
    if(cell.planet == nil) {
        int n = arc4random() % self.ncells;
        if(n < max_planets) {
            // this will be true with P(max_planets / ncells) might want to change this
            int p = arc4random() % [self.loadedPlanets count];
            planet = [self.loadedPlanets objectAtIndex:p];
            [cell addPlanet:[planet copy]];
            //[cell addPlanet:[self.loadedPlanets objectAtIndex:p]];
            [self.usedPlanets addObject:[self.loadedPlanets objectAtIndex:p]];
            planets++;
        }    
    }
    // keep checking directions until we find one that is on the grid
    int d = -1;
    NSString *dir;
    while(d == -1) {
        dir = [self getRandomDirectionName];
        d = [self getIndexInDirection:x dir:dir];
    }
    // set the exit we are leaving to be a pointer to the location of the 
    // cell we are going to and the opposite direction in the new cell we
    // are going to where we were
    Cell *newcell = [self.cells objectAtIndex:d];
    [cell.exits setObject:newcell forKey:dir];
    [newcell.exits setObject:cell forKey:[self.oppositeDirectionName objectForKey:dir]];
    [self checkAndMove:d planets:planets max_planets:max_planets];
    return false;
}

- (int) getIndexInDirection:(int) x dir:(NSString *)dir {
    if([dir isEqualToString:@"north"]) {
        return [self getNorth:x];
    }
    if([dir isEqualToString:@"south"]) {
        return [self getSouth:x];
    }
    if([dir isEqualToString:@"east"]) {
        return [self getEast:x];
    }
    if([dir isEqualToString:@"west"]) {
        return [self getWest:x];
    }
    else return(-1);
}

- (NSString *) getRandomDirectionName {
    int n = arc4random() % [self.exitNames count];
    return([self.exitNames objectAtIndex:n]);
}

- (int) getEast:(int) x {
    if ((x + 1) % self.cols == 0) {
        return -1;
    }
    else {
        return (x + 1);
    }
}

- (int) getWest:(int) x {
    if ((x % self.cols) == 0) {
        return -1;
    }
    else {
        return (x - 1);
    }
}

- (int) getNorth:(int) x {
    if ((x - self.cols) < 0) {
        return -1;
    }
    else {
        return (x - self.cols);
    }
}

- (int) getSouth:(int) x {
    if ((x + self.cols) >= self.ncells) {
        return -1;
    }
    else {
        return (x + self.cols);
    }
}

@end

