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

- (id)init
{
    self = [super init];
    if (self) {
        self.rows = 0;
        self.cols = 0;
        self.ncells = 0;
        self.cells = [[NSMutableArray alloc] init];
    }    
    return self;
}

- (void) setSize:(int)x y:(int)y {
    assert((x > 0) && (y > 0));
    self.rows = x;
    self.cols = y;
    self.ncells = x * y;
    for(int i = 0; i < self.ncells; i++) {
        Cell *c = [Cell init];
        [self.cells addObject:c];
    }
}

- (bool) checkAndMove:(int) x planets:(int)planets max_planets:(int)max_planets {
    if(planets >= max_planets) {
        return true;
    }
    Cell *cell = [cells objectAtIndex:x];
    if(cell.planet == nil) {
        int n = arc4random() % self.ncells;
        if(n < max_planets) {
            // this will be true with P(max_planets / ncells) might want to change this
            // XXX right now doesn't read in a planet config from anywhere so
            // XXX just put a blank planet
            Planet *planet = [Planet init];
            cell.planet = planet;
            planets += planets;
        }
    }
    // keep checking directions until we find one that is on the grid
    int d = -1;
    NSString *dir;
    while(d == -1) {
        NSString *dir = [self getRandomDirection];
        d = [self getDirection:x dir:dir];
    }

    // set the exit we are leaving to be a pointer to the location of the 
    // cell we are going to and the opposite direction in the new cell we
    // are going to where we were
    Cell *newcell = [cells objectAtIndex:d];
    [cell.exits setObject:newcell forKey:dir];
    [newcell.exits setObject:cell forKey:[self getOppositeDirection:dir]];
    [self checkAndMove:d planets:planets max_planets:max_planets];
    
    return false;
}

- (NSString *) getOppositeDirection:(NSString *)dir {
    NSMutableDictionary *opp;
    [opp setObject:@"south" forKey:@"north"];
    [opp setObject:@"north" forKey:@"south"];
    [opp setObject:@"east" forKey:@"west"];
    [opp setObject:@"west" forKey:@"east"];
    return([opp objectForKey:dir]);
}
- (int) getDirection:(int) x dir:(NSString *)dir {
    if(dir == @"north") {
        return [self getNorth:x];
    }
    if(dir == @"south") {
        return [self getSouth:x];
    }
    if(dir == @"east") {
        return [self getEast:x];
    }
    if(dir == @"west") {
        return [self getWest:x];
    }
    else return(-1);
}
- (NSString *) getRandomDirection {
    NSMutableArray *exits = [NSMutableArray arrayWithObjects:@"north", @"south", @"east", @"west", nil]; 
    int n = arc4random() % [exits count];
    return([exits objectAtIndex:n]);
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
    if ((x - 1) % self.cols == (self.cols -1)) {
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
    if ((x + self.cols) >= self.cols) {
        return -1;
    }
    else {
        return (x + self.cols);
    }
}

@end

