    //
//  MapGenerator.m
//  Quarkeon Express
//
//  Created by Rory Kirchner on 10/28/11.
//  Copyright 2011 MIT. All rights reserved.
//

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
    }    
    return self;
}

- (void) setSize:(int)x y:(int)y {
    assert((x > 0) && (y > 0));
    self.rows = x;
    self.cols = y;
    self.ncells = x * y;
    for(int i = 0; i < self.ncells; i++) {
        Cell *c = [[Cell alloc] init];
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
    if(planets >= max_planets) {
        return true;
    }
    Cell *cell = [self.cells objectAtIndex:x];
    cell.ongrid = true;
    if(cell.planet == nil) {
        int n = arc4random() % self.ncells;
        if(n < max_planets) {
            // this will be true with P(max_planets / ncells) might want to change this
            // XXX right now doesn't read in a planet config from anywhere so
            // XXX just put a blank planet
            int p = arc4random() % [self.loadedPlanets count];
            cell.planet = [self.loadedPlanets objectAtIndex:p];
            [self.usedPlanets addObject:[self.loadedPlanets objectAtIndex:p]];
            planets++;
        }    
    }
    // keep checking directions until we find one that is on the grid
    int d = -1;
    NSString *dir = [self getRandomDirectionName];
    while(d == -1) {
        NSString *dir = [self getRandomDirectionName];
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

