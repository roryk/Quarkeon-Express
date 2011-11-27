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
@synthesize visitedBy;
@synthesize type;
@synthesize picture;
@synthesize planetID;
@synthesize description;
@synthesize currentCost, initialCost, earnRate;
@synthesize owner;
@synthesize x,y;

- (id)init
{
    self = [super init];
    if (self) {
        self.owner = nil;
        self.planetID = -1;
        self.currentCost = -1;
        self.initialCost = -1;
        self.x = -1;
        self.y = -1;
        self.picture = nil;
        self.name = [NSString string];
        self.description = [NSString string];
        // XXX SET THIS FOR TESTING UNSET AFTER
        self.earnRate = 20; // don't want -1 here as a default
        self.visitedBy = [NSMutableArray array];
        // Initialization code here.
    }
    
    return self;
}

- (Planet *)copy {
    Planet *newPlanet = [[Planet alloc] autorelease];
    newPlanet.planetID = self.planetID;
    newPlanet.owner = nil;
    newPlanet.initialCost = self.initialCost;
    newPlanet.currentCost = self.currentCost;
    newPlanet.picture = self.picture;
    newPlanet.earnRate = self.earnRate;
    newPlanet.description = self.description;
    newPlanet.name = self.name;
    newPlanet.picture = self.picture;
    newPlanet.type = self.type;
    newPlanet.x = self.x;
    newPlanet.y = self.y;
    return(newPlanet);
}


- (bool) hasVisited:(Player *)player {
    return [self.visitedBy indexOfObject:player];
}

@end