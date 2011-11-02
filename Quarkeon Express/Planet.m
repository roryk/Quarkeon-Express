//
//  Planet.m
//  Quarkeon Express
//
//  Created by Adam Fletcher on 10/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Planet.h"
#import "SpaceLane.h"
#import "Player.h"

@implementation Planet

@synthesize name;
@synthesize challenge;
@synthesize north, south, east, west;
@synthesize visitedBy;
@synthesize type;
@synthesize picture;
@synthesize planetID;
@synthesize description;
@synthesize currentCost, initialCost, earnRate;
@synthesize owner;

- (id)init
{
    self = [super init];
    if (self) {
        self.challenge = nil;
        self.north = nil;
        self.south = nil;
        self.east = nil;
        self.west = nil;
        self.owner = nil;
        self.planetID = -1;
        self.currentCost = -1;
        self.initialCost = -1;
        // XXX SET THIS FOR TESTING UNSET AFTER
        self.earnRate = 20; // don't want -1 here as a default
        self.visitedBy = [NSMutableArray array];
        // Initialization code here.
    }
    
    return self;
}

- (SpaceLane *)getLane:(NSString *)lane {
    if ([lane isEqualToString:@"n"]) {
        return north;
    }
    if([lane isEqualToString:@"s"]) {
        return south;
    }
    if([lane isEqualToString:@"e"]) {
        return east;
    }
    if([lane isEqualToString:@"w"]) {
        return west;
    }
    else return nil;
}

- (bool)hasLane:(NSString *)lane {
    if ([self getLane:lane] == nil) {
        return FALSE;
    }
    else return TRUE;
}

- (bool) hasVisited:(Player *)player {
    return [self.visitedBy indexOfObject:player];
}

@end